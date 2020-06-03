<?xml version="1.0" encoding="UTF-8"?>
<!-- 

  This stylesheet alters the structure of the elements from the utility domain.

-->
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  xmlns:oxy="http://www.oxygenxml.com/extensions/author"
  xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
  xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
  xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
  
  exclude-result-prefixes="#all">

  
  	<!--
  		Convert the imagemap to a div containing the image and the list of links.
  	-->
    <xsl:template match="*[contains(@class,' ut-d/imagemap ')]">
        <div>
          <xsl:call-template name="commonattributes"/>
          <xsl:apply-templates select="*[contains(@class,' topic/image ')]"/>
          <ol class="imagemap--areas">
            <xsl:apply-templates select="*[contains(@class,' ut-d/area ')]"/>
          </ol>
        </div>
    </xsl:template>

    <xsl:template match="*[contains(@class,' ut-d/area ')]">
        <li>
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="*[contains(@class,' ut-d/shape ')]"/>

    <xsl:template match="*[contains(@class,' ut-d/coords ')]"/>
</xsl:stylesheet>