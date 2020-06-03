<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

  <xsl:key name="fnById" match="*[contains(@class, ' topic/fn ')]" use="@id"/>

  <!-- Do not process footnotes with id. -->
  <xsl:template match="*[contains(@class, ' topic/fn ')][@id]"/>

  <!-- Process xref @type='fn' and replace them by their referenced footnotes. -->
  <xsl:template match="*[contains(@class, ' topic/xref ')][@type = 'fn']" priority="2">
    <xsl:variable name="href-fragment" select="substring-after(@href, '#')"/>
    <xsl:variable name="elemId" select="substring-after($href-fragment, '/')"/>
    <xsl:variable name="topicId" select="substring-before($href-fragment, '/')"/>
    <xsl:variable name="footnote-target"
      select="(key('fnById', $elemId)[ancestor::*[contains(@class, ' topic/topic ')][1]/@id = $topicId])[1]"
      as="element()?"/>
    <xsl:apply-templates select="$footnote-target" mode="copy-fn-no-id"/>
  </xsl:template>
  
  <!-- Copy footnote without @id to avoid duplicate ids in merged files. -->
  <xsl:template match="node() | @*" mode="copy-fn-no-id">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@id" mode="copy-fn-no-id"/>
  
</xsl:stylesheet>
