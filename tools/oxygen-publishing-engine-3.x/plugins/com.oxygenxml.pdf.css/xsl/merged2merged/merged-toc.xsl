<!-- 
    
    This stylesheet processes the TOC.

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:oxy="http://www.oxygenxml.com/extensions/author"
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="#all">
    
    <!-- Mapping from topic id to topicref. -->
    <xsl:key name="map-id" match="//*[contains(@class, ' map/topicref ')]" use="@id"/>
    
    <!-- Remove the the link text, leave only the navtitle, which has markup. -->
    <xsl:template match="opentopic:map//*[contains(@class, ' map/linktext ')]"/>
    
    <!-- Remove the reltables from the toc. -->
    <xsl:template match="opentopic:map//*[contains(@class, ' map/reltable ')]"/>
    
    <!-- Remove the id from the topicref. The id is declared again in the topic from the main content and would break linking. -->
    <xsl:template match="opentopic:map//*[contains(@class, ' map/topicref ')]/@id"/>

    
    <!-- Remove the TOC reference from the frontmatter or backmatter TOC sections. -->
    <xsl:template match="*[contains(@class, ' bookmap/toc ')]"/>
    
    <!-- For parts without topic meta that have just a @navtitle, generate a topicmeta for it. 
         (This happens for bookmap parts with just a navtitile and have no href)-->
    <xsl:template match="opentopic:map//*[contains(@class, ' map/topicref ')][not(*[contains(@class, ' map/topicmeta ')])][@navtitle]" priority="2">
        <xsl:copy>
            <xsl:apply-templates select="@* except @id"/>            
            <topicmeta class="- map/topicmeta ">
                <navtitle class="- topic/navtitle " href="#{@id}"><xsl:value-of select="@navtitle"/></navtitle>
            </topicmeta>                    
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Exclude references marked as not entering the TOC. -->
    <xsl:template match="opentopic:map//*[contains(@class, ' map/topicref ')][@toc = 'no']" priority="100"/>
    
    <!-- Remove the markup from the <navtitle> children. 
         It causes Prince to break the lines in the TOC before and after each of the 
         inline elements. -->
    <xsl:template match="opentopic:map//*[contains(@class, ' topic/navtitle ')]">
        <xsl:copy>
            <xsl:call-template name="navtitle.href"/>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()|*" mode="navtitle"/>            
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' topic/tm ')]" mode="navtitle">
    	<xsl:choose>
        	<xsl:when test="starts-with($transtype, 'pdf-css-html5')">
            	<!-- Leave it as it is, the full markup will be transformed in merge2html stage. -->
                <xsl:apply-templates select="." mode="#default"/>
          	</xsl:when>
          	<xsl:otherwise>
                <!-- The direct XML + CSS transformation -->
          		<!-- Output the text. -->
          		<xsl:apply-templates mode="navtitle"/>
          		<!-- And the trademark symbol. -->
	          	<xsl:choose>
			            <xsl:when test="@tmtype = 'tm'">&#8482;</xsl:when>
			            <xsl:when test="@tmtype = 'reg'">&#174;</xsl:when>
			            <xsl:when test="@tmtype = 'service'">&#8480;</xsl:when>
			        </xsl:choose>          	
          	</xsl:otherwise>
    	</xsl:choose>
    </xsl:template>
    <xsl:template name="navtitle.href">
        <xsl:attribute name="href">
            <xsl:variable name="closestTopicref"
                select="ancestor-or-self::*[contains(@class, ' map/topicref ')][1]"/>
            <xsl:variable name="tid" select="$closestTopicref/@first_topic_id"/>
            <xsl:choose>
                <xsl:when test="$tid">
                    <xsl:value-of select="$tid"/>
                </xsl:when>
                <!-- EXM-32190 Sometimes, when we have chunk=to-content on the root element, the first_topic_id attribute might be missing -->
                <xsl:when test="not($closestTopicref/@id = '')">
                    <!-- Do not use the @href attribute, it does not point to the topic from the content.
                    Instead, use the @id, it has the same value as the @id from the content. -->
                    <!-- The id may be empty if having an external ref to a PDF for example. -->
                    <xsl:value-of select="concat('#', $closestTopicref/@id)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$closestTopicref/@href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    
    
    <!-- 
        Sometimes the @navtitle attribute on the topicref element is used instead 
        of the <topicmeta>/<navtitle> element.
        DITA-OT generates a linktext in this case. To simplify CSS processing,
        we'll create a navtitle out of the linktext.
    -->
    <xsl:template match="opentopic:map//topicmeta[linktext][not(navtitle)]">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <navtitle class="- topic/navtitle ">
                <xsl:call-template name="navtitle.href"/>
                <xsl:value-of select="linktext"/>
            </navtitle>
        </xsl:copy>
    </xsl:template>

    <!-- 
    	Use the @navtitle from the topicref, in case of topicheads. For 
    	topicheads, the topicmeta is not updated properly by DITA-OT.
	-->
  <xsl:template match="opentopic:map//topicmeta[not(linktext)][not(navtitle)][../@navtitle] |
  					   opentopic:map//topicmeta[../@locktitle='yes'][../@navtitle]" priority="2">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <navtitle class="- topic/navtitle ">
                <xsl:call-template name="navtitle.href"/>
                <xsl:value-of select="../@navtitle"/>
            </navtitle>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- 
        Processes the opentopic:map element, this gives the main structure of the TOC.
    -->
    <xsl:template match="opentopic:map">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="class" select="'- toc/toc '"/>
            
            <!-- 
                Adds a title to the TOC. 
                The title is taken from the toc element @navtitle attribute.
                If it does not exist, leave the placeholder element in place 
                and mark it as empty, so it can be styled from CSS.
            -->            
            <oxy:toc-title class="- toc/title ">
                <xsl:variable name="toc-navtitile" select="//toc[1]/@navtitle"/>
                <xsl:choose>
                    <xsl:when test="$toc-navtitile">
                        <xsl:value-of select="$toc-navtitile"/>                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="empty" select="'true'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </oxy:toc-title>
            
            <!-- 
                Adds the TOC main content.
            -->
            <xsl:apply-templates select="node()"/>
            
            <!-- 
                Add a reference to the generated index element,
                but only if it contains at least one child and 
                there is not a reference to the index by means for 
                a indexlist element in the bookmap.
            -->
            <xsl:variable name="indexElem" select="//opentopic-index:index.groups[1]"/>
            <xsl:if test="$indexElem/* and not (//*[contains(@class, ' bookmap/indexlist ')]) and 
            			  $hide.frontpage.toc.index.glossary = 'no'">
            			  
                <xsl:variable name="indexId" select="generate-id($indexElem)"/>
                <topicref is-chapter="true" is-index="true" class="- map/topicref ">
                    <topicmeta class="- map/topicmeta ">
                        <navtitle href="#{$indexId}" class="- topic/navtitle ">
                         <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Index'"/>
                         </xsl:call-template>
                        </navtitle>
                    </topicmeta>
                </topicref>
            </xsl:if>
        </xsl:copy>
    </xsl:template>
    
    <!-- 
    	The topicgroup element is for creating groups of topicref elements without affecting 
    	the hierarchy. 
    -->
    <xsl:template match="*[contains(@class,' mapgroup-d/topicgroup ')]">
      <xsl:apply-templates />
    </xsl:template>
    
</xsl:stylesheet>