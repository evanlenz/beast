<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:d="http://github.com/vinniefalco/docca"
  expand-text="yes">

  <xsl:output method="text"/>

  <xsl:import href="common.xsl"/>

  <xsl:include href="config.xsl"/>
  <xsl:include href="emphasized-types.xsl"/>

  <xsl:param name="DEBUG" select="false()"/>

  <xsl:variable name="list-indent-width" select="4"/>

  <xsl:template mode="before" match="/page">
    <xsl:text>{$nl}</xsl:text>
    <xsl:text>[section:{@section-id} {d:qb-escape(title)}]</xsl:text>
    <xsl:apply-templates mode="indexterm" select="."/>
  </xsl:template>

          <xsl:template mode="indexterm" match="page"/>
          <xsl:template mode="indexterm" match="page[@index-parent]"
            >{$nl}[indexterm2 {d:qb-escape(@section-name)}..{d:qb-escape(@index-parent)}]{$nl}</xsl:template>

  <!-- Title is already included in section header -->
  <xsl:template match="/page/title"/>

  <xsl:template match="heading">{$nl}[heading {.}]</xsl:template>

  <xsl:template match="location">
    <xsl:apply-templates mode="includes-template" select="."/>
  </xsl:template>

  <xsl:template match="footer/location">
    <xsl:apply-templates mode="includes-footer" select="."/>
  </xsl:template>

  <xsl:template mode="before" match="compound | function | typedef | overloaded-member">{$nl}```{$nl}</xsl:template>
  <xsl:template mode="after"  match="compound | function | typedef | overloaded-member">{$nl}```{$nl}</xsl:template>

  <xsl:template mode="append" match="function">;</xsl:template>

  <!-- Merge adjacent overloaded-members into one syntax block, separated by one blank line -->
  <xsl:template mode="before" match="overloaded-member[preceding-sibling::*[1]/self::overloaded-member]">{$nl}{$nl}</xsl:template>
  <xsl:template mode="after"  match="overloaded-member[following-sibling::*[1]/self::overloaded-member]"/>

  <xsl:template mode="after" match="overloaded-member/type[normalize-space(.)]
                                  |          function/type[normalize-space(.)]">{$nl}</xsl:template>

  <xsl:template mode="before" match="overloaded-member/link">``</xsl:template>
  <xsl:template mode="after"  match="overloaded-member/link">``</xsl:template>

  <xsl:template mode="append" match="overloaded-member">
    <xsl:text>;{$nl}</xsl:text>
    <xsl:variable name="more-link" as="element()">
      <emphasis>'''&amp;raquo;''' <link to="{link/@to}">more...</link></emphasis>
    </xsl:variable>
    <xsl:text>  ``</xsl:text>
    <xsl:apply-templates select="$more-link"/>
    <xsl:text>``</xsl:text>
  </xsl:template>

  <xsl:template match="link">[link {$doc-ref}.{@to} {d:qb-escape(.)}]</xsl:template>

  <xsl:template mode="before" match="typedef/name">using </xsl:template>
  <xsl:template mode="after"  match="typedef/name"> = </xsl:template>
  <xsl:template mode="after"  match="typedef/type">;</xsl:template>

  <xsl:template match="type[. eq '__implementation_defined__'    ]">``['implementation-defined]``</xsl:template>
  <xsl:template match="type[. eq '__see_below__'                 ]">``['see-below]``</xsl:template>
  <xsl:template match="type[. = ('__deduced__','void_or_deduced')]">``__deduced__``</xsl:template>

  <xsl:template mode="after" match="compound/kind">{' '}</xsl:template>

  <xsl:template mode="before" match="templateparamlist">template&lt;</xsl:template>
  <xsl:template mode="after"  match="templateparamlist">>{$nl}</xsl:template>

  <xsl:template mode="before" match="param">{$nl}    </xsl:template>
  <xsl:template mode="after"  match="param[position() ne last()]">,</xsl:template>

  <xsl:template mode="after" match="param[declname]/type">{' '}</xsl:template>


  <xsl:template mode="before" match="params">(</xsl:template>
  <xsl:template mode="after"  match="params">)</xsl:template>

  <xsl:template match="templateparamlist/param/declname[. = $emphasized-template-parameter-types]"
    >__{translate(.,'_','')}__</xsl:template>

  <xsl:template mode="before" match="defval"> = </xsl:template>

  <xsl:template mode="before" match="modifier[. eq 'const']">{' '}</xsl:template>
  <xsl:template mode="after"  match="modifier[. eq 'const']"/>

  <xsl:template mode="after"  match="modifier">{$nl}</xsl:template>


  <xsl:template mode="#all" match="ERROR">[role red error.{@message}]</xsl:template>

  <xsl:template mode="before" match="table">{$nl}[table </xsl:template>
  <xsl:template mode="after"  match="table">{$nl}]</xsl:template>

  <!-- ASSUMPTION: table rows have either <th> or <td>, not both -->
  <xsl:template mode="before" match="tr[th] | th">[</xsl:template>
  <xsl:template mode="after"  match="tr[th] | th">]</xsl:template>

  <xsl:template mode="before" match="tr">{$nl}  [</xsl:template>
  <xsl:template mode="after"  match="tr">{$nl}  ]</xsl:template>

  <xsl:template mode="before" match="td">{$nl}    [</xsl:template>
  <xsl:template mode="after"  match="td">{$nl}    ]</xsl:template>

  <xsl:template mode="before" match="bold"    >[*</xsl:template>
  <xsl:template mode="after"  match="bold"    >]</xsl:template>

  <xsl:template mode="before" match="emphasis">['</xsl:template>
  <xsl:template mode="after"  match="emphasis">]</xsl:template>

  <xsl:template mode="before" match="computeroutput | code">`</xsl:template>
  <xsl:template mode="after"  match="computeroutput | code">`</xsl:template>

  <xsl:template match="listitem">
    <xsl:text>{$nl}</xsl:text>
    <xsl:apply-templates mode="list-item-indent" select="."/>
    <xsl:apply-templates mode="list-item-label" select=".."/>
    <xsl:text> </xsl:text>
    <!-- ASSUMPTION: <para> always appears as a child of list items -->
    <xsl:apply-templates select="para/node()"/>
  </xsl:template>

          <!-- TODO: verify this works as expected (find an example of a nested list) -->
          <xsl:template mode="list-item-indent"
                        match="listitem">{ancestor::listitem ! (1 to $list-indent-width) ! ' '}</xsl:template>

          <xsl:template mode="list-item-label" match="itemizedlist">*</xsl:template>
          <xsl:template mode="list-item-label" match="orderedlist" >#</xsl:template>

  <xsl:template mode="append" match="/page/div[1]">
    <xsl:if test="$DEBUG">
      <xsl:text>['</xsl:text>
      <xsl:text>[role red \[Page type: [*{/*/@type}]\]] </xsl:text>
      <xsl:text>[role green \[[@../../doc/html/beast/ref/{translate(/page/@id,'.','/')}.html [role green doc_build_html]]\]] </xsl:text>
      <xsl:text>[@../build/xml-pages/{/page/@id}.xml                     [role blue   [*\[stage1_source_xml\]]]]</xsl:text>
      <xsl:text>[@../build/stage1_visualized/visualized/{/page/@id}.html [role magenta ---stage1_visualized-->]]</xsl:text>
      <xsl:text>[@../build/stage1_visualized/results/{   /page/@id}.xml  [role blue   [*\[stage2_source_xml\]]]]</xsl:text>
      <xsl:text>[@../build/stage2_visualized/visualized/{/page/@id}.html [role magenta ---stage2_visualized-->]]</xsl:text>
      <xsl:text>[@../build/stage2_visualized/results/{   /page/@id}.xml  [role blue   [*\[stage2_result_qbk\]]]]</xsl:text>
      <xsl:text>]</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="before" match="para | div">{$nl}</xsl:template>

  <xsl:template match="sp">{' '}</xsl:template>

  <xsl:template mode="before" match="programlisting">{$nl}```{$nl}</xsl:template>
  <xsl:template mode="after"  match="programlisting"     >```{$nl}</xsl:template>

  <xsl:template mode="after" match="codeline">{$nl}</xsl:template>

  <!-- Ignore whitespace-only text nodes -->
  <xsl:template match="text()[not(normalize-space())]"/>

  <!-- Boilerplate default rules for elements -->
  <!-- Convention of this stylesheet is to favor use of just "before" and "after"
       and to utilize "append" (and maybe "insert") only when a distinction is needed -->
  <xsl:template match="*" priority="1">
    <xsl:apply-templates mode="before" select="."/>
    <!-- enable if needed/desired
    <xsl:apply-templates mode="insert" select="."/> -->
    <xsl:next-match/>
    <xsl:apply-templates mode="append" select="."/>
    <xsl:apply-templates mode="after" select="."/>
  </xsl:template>

          <!-- Default before/after/insert/append rules are to do nothing -->
          <xsl:template mode="before" match="*"/>
          <!-- enable if needed/desired
          <xsl:template mode="insert" match="*"/> -->
          <xsl:template mode="append" match="*"/>
          <xsl:template mode="after" match="*"/>


  <xsl:function name="d:qb-escape">
    <xsl:param name="string"/>
    <xsl:sequence select="replace(
                            replace($string, '\[', '\\['),
                            '\]',
                            '\\]'
                          )"/>
  </xsl:function>

</xsl:stylesheet>
