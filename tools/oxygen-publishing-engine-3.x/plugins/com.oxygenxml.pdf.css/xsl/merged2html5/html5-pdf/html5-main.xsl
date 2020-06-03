<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:css-param="http://www.oxygenxml.com/extensions/publishing/dita/css/params"
                exclude-result-prefixes="#all" >
  <xsl:param name="html5.css.links" />
  
  <!-- Add the links to the CSS files to the HTML head. -->
  <xsl:template name="generateCssLinks">
    <xsl:if test="$html5.css.links">    
      <xsl:text>&#10;</xsl:text>
      <xsl:value-of select="$html5.css.links" disable-output-escaping="yes"/>
    </xsl:if>
  </xsl:template>  
  
  <!-- Add the publication title to the HTML head. -->
  <xsl:template name="generateChapterTitle">
    <title>
     
      <xsl:choose>
        <xsl:when test="@title">
          <xsl:value-of select="@title"/>
        </xsl:when>
        <xsl:when test="*[contains(@class, ' topic/title ')]">
          <xsl:value-of select="*[contains(@class, ' topic/title ')]"/>            
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="*[contains(@class, ' front-page/front-page ')]
                                  /*[contains(@class, ' front-page/front-page-title ')]
                                   /*[contains(@class, ' bookmap/booktitle ')]
                                    /*[contains(@class, ' bookmap/mainbooktitle ')]"/>
        </xsl:otherwise>
      </xsl:choose>
      
    </title>
  </xsl:template>
    
  <xsl:template match="/*">
    <html>
      <!-- This can be used to solve relative images -->
      <xsl:copy-of select="@xtrf"/>

      <xsl:apply-templates select="@css-param:*"/>
      
      <xsl:call-template name="chapterHead"/>
      <body class="wh_topic_page">
          <div class="wh_content_area">
            <div class="wh_topic_body">
              <div class="wh_topic_content">
                <div>
                  <xsl:apply-templates select="@css-param:*"/>
                  <xsl:call-template name="commonattributes"/>
                  <xsl:apply-templates/>
                </div>
              </div>
            </div>
          </div>
      </body>
    </html>
  </xsl:template>

  <!--
   These are additional root attributes add also a version without namespace,
   so the browsers can be used to debug the styling. -->
  <xsl:template match="@css-param:*" priority="2">
    <xsl:copy-of select="."/>
    <xsl:attribute name="{local-name()}" select="."/>
  </xsl:template>
  
</xsl:stylesheet>