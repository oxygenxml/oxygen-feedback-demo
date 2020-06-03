<?xml version="1.0" encoding="UTF-8"?>
<!-- 

  This stylesheet changes the tables structure.

-->
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  xmlns:oxy="http://www.oxygenxml.com/extensions/author"
  xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
  xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
  xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:table="http://dita-ot.sourceforge.net/ns/201007/dita-ot/table"
  
  exclude-result-prefixes="#all">
  
  <xsl:param name="table.title.placement" select="'top'"/>
  <xsl:param name="table.title.repeat" select="'yes'"/>

  <!-- DCP-270 Putting a topic/title class on the caption, so it can be 
    styled together with all other titles from the publication.
    -->
  <xsl:template match="*[contains(@class, ' topic/table ')][child::*[contains(@class, ' topic/title ')]]" mode="table:title">
    <caption class="- topic/title title tablecap">
      <xsl:attribute name="caption-side" select="$table.title.placement"/>
      <xsl:if test="$table.title.repeat = 'yes'">
        <xsl:attribute name="is-repeated">true</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="label"/>
      <xsl:apply-templates select="
        *[contains(@class, ' topic/title ')] | *[contains(@class, ' topic/desc ')]
        "/>
    </caption>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]" name="topic.table_title">
    <span>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="setid"/>
      <xsl:attribute name="class" select="'table--title'" />
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <!-- DCP-263 The number from the table label is wrapped in a span, so it can be styled from CSS. -->
  <xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]" mode="title-number">
    <xsl:param name="number" as="xs:integer"/>
    <xsl:value-of select="dita-ot:get-variable(., 'Table')"/>
    <span class="table--title-label-number">
      <xsl:text> </xsl:text>
      <xsl:sequence select="$number"/>
    </span>
    <span class="table--title-label-punctuation">
      <xsl:text>. </xsl:text>
    </span>
  </xsl:template>

  
  <!-- 
    WH-1485: Add a wrapper for simple tables, in order to avoid
    wide tables overflowing the topic content area. 
  -->
  <xsl:template match="*[contains(@class, ' topic/simpletable ')]" priority="2">
    <div class="simpletable-container">
      <xsl:next-match/>
    </div>
  </xsl:template>
</xsl:stylesheet>