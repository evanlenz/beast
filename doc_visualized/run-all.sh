#!/bin/bash

echo "Copying docca XSLT files..." && \
cp ../doc/docca/include/docca/* build && \

echo "Copying xslt-visualizer..." && \
cp -r ../doc/docca/include/xslt-visualizer build && \

echo "Copying shell scripts..." && \
cp extract-xml-pages.sh \
   prepare.sh \
   trace.sh \
   render.sh \
   assemble-quickbook.sh \
build && \

cd build && \

echo "Calling extract-xml-pages.sh..." && \
./extract-xml-pages.sh && \

echo "Calling prepare.sh..." && \
./prepare.sh && \

echo "Calling trace.sh..." && \
./trace.sh && \

echo "Calling render.sh..." && \
./render.sh && \

echo "Calling assemble-quickbook.sh..." && \
./assemble-quickbook.sh && \

echo "Calling the Beast build to run the Quickbook -> BoostBook -> DocBook -> HTML conversion..." && \
cd .. && \
../../../b2.exe






# Everything below tries to replicate what the b2.exe call does above
#echo "Copying reference.qbk into qbk..." && \
#cp ../reference.qbk ../qbk && \

#echo "Converting QuickBook (main.qbk) to BoostBook (beast_doc.xml)..." && \
#../../../../bin.v2/tools/quickbook/src/msvc-14.2/release/cxxstd-0x-iso/link-static/threading-multi/quickbook.exe --output-file=beast_doc.xml ../qbk/main.qbk && \

#echo "Converting BoostBook (beast_doc.xml) to DocBook (beast_doc.docbook)..." && \
#set XML_CATALOG_FILES=../../../../bin.v2/boostbook_catalog.xml && \
#/usr/bin/xsltproc --stringparam boost.defaults "Boost" --stringparam boost.root "../../../.." --stringparam chapter.autolabel "1" --stringparam chunk.first.sections "1" --stringparam chunk.section.depth "8" --stringparam generate.section.toc.level "8" --stringparam generate.toc "chapter toc,title section nop reference nop" --stringparam toc.max.depth "8" --stringparam toc.section.depth "8" --path "../../../../bin.v2" --xinclude -o beast_doc.docbook ../../../../tools/boostbook/xsl/docbook.xsl beast_doc.xml && \


#echo "Converting DocBook (beast_doc.docbook) to HTML..." && \
#set XML_CATALOG_FILES=../../../../bin.v2/boostbook_catalog.xml && \
#/usr/bin/xsltproc --stringparam boost.defaults "Boost" --stringparam boost.root "../../../.." --stringparam chapter.autolabel "1" --stringparam chunk.first.sections "1" --stringparam chunk.section.depth "8" --stringparam generate.section.toc.level "8" --stringparam generate.toc "chapter toc,title section nop reference nop" --stringparam manifest "beast_HTML.manifest" --stringparam toc.max.depth "8" --stringparam toc.section.depth "8" --path "../../../../bin.v2" --xinclude -o ../html/ ../../../../tools/boostbook/xsl/html.xsl beast_doc.docbook
