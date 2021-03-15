<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:css-param="http://www.oxygenxml.com/extensions/publishing/dita/css/params"
                exclude-result-prefixes="#all" >
  
  <!-- Collect the keywords -->
  <xsl:template match="*" mode="gen-keywords-metadata">
    <xsl:variable name="keywords-content-at-map-level">
      <xsl:for-each select="descendant::*[contains(@class,' front-page/front-page ')]/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/keywords ')]/descendant-or-self::*">
          <!-- for each item inside keywords (including nested index terms) -->
          <xsl:if test="position()>2"><xsl:text>, </xsl:text></xsl:if>
          <xsl:value-of select="normalize-space(text()[1])"/>
      </xsl:for-each>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="string-length($keywords-content-at-map-level)">
        <!-- Map level keywords, these will be considered as important. -->
        <meta name="keywords" content="{$keywords-content-at-map-level}"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- Let the default processing, that collects all keywords and indexterms from the content of the topics. -->
        <xsl:variable name="keywords-content">
          <xsl:next-match/>
        </xsl:variable>
		<!-- Leave only the 'keywords' metadata element. -->
        <xsl:apply-templates select="$keywords-content" mode="clean-keywords-metadata"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="node() | @*" mode="clean-keywords-metadata">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Do not process the DC.subject metadata. -->
  <xsl:template match="meta[@name='DC.subject']" mode="clean-keywords-metadata"/>
  
</xsl:stylesheet>