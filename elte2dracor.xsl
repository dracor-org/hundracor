<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="tei"
  version="3.0">

  <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>

  <xsl:param name="index" select="document('index.xml')"/>
  <xsl:param name="outputdirectory">tei</xsl:param>
  <xsl:param name="eventcontent">label</xsl:param>

  <xsl:variable
    name="filename"
    select="replace(tokenize(base-uri(.), '/')[last()], '.xml', '')"/>

  <xsl:variable name="meta" select="$index//item[@file eq $filename]"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$meta">
        <xsl:variable
          name="target"
          select="concat($outputdirectory, '/', $meta/@slug, '.xml')"/>
        <xsl:message select="$filename || ': ' || $target"/>
        <xsl:result-document href="{$target}">
          <xsl:apply-templates select="tei:TEI"/>
        </xsl:result-document>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Unknown document ID: </xsl:text>
          <xsl:value-of select="$filename"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:TEI">
    <TEI xml:id="{$meta/@id}" xml:lang="hun">
      <xsl:apply-templates/>
    </TEI>
  </xsl:template>

  <xsl:template match="tei:teiHeaderXXX">
    <xsl:copy/>
    <standOff>
      <xsl:if test="$meta/@wikidata">
        <listRelation>
          <relation name="wikidata">
            <xsl:attribute name="active">
              <xsl:text>https://dracor.org/entity/</xsl:text>
              <xsl:value-of select="$meta/@id"/>
            </xsl:attribute>
            <xsl:attribute name="passive">
              <xsl:text>http://www.wikidata.org/entity/</xsl:text>
              <xsl:value-of select="$meta/@wikidata"/>
            </xsl:attribute>
          </relation>
        </listRelation>
      </xsl:if>
    </standOff>
  </xsl:template>

  <xsl:template match="tei:teiHeader">
    <xsl:variable name="dates" select="
      /tei:TEI/tei:teiHeader//tei:sourceDesc//tei:bibl
        [@type='originalSource' or @type='firstEdition']
        /tei:date
          [@type='print' or  @type='premiere' or @type='written']
          [@when != '' or @notBefore or @notAfter]"/>
    <xsl:variable
      name="wd-idno"
      select="/tei:TEI//tei:publicationStmt/tei:idno[@type='wikidata']"/>

    <teiHeader>
      <xsl:apply-templates/>
    </teiHeader>

    <xsl:if test="not(/tei:TEI/tei:standOff) and ($dates or $meta/@wikidata)">
      <standOff>
        <xsl:if test="$dates">
          <listEvent>
            <xsl:for-each select="$dates">
              <event type="{@type}">
                <xsl:for-each select="@when|@notBefore|@notAfter">
                  <xsl:attribute name="{local-name()}">
                    <xsl:value-of select="."/>
                  </xsl:attribute>
                </xsl:for-each>
                <xsl:variable name="content" select="text()"/>
                <xsl:choose>
                  <xsl:when test="not($content) or $content eq @when">
                    <desc/>
                  </xsl:when>
                  <xsl:when test="$eventcontent eq 'label'">
                    <label><xsl:value-of select="$content"/></label>
                  </xsl:when>
                  <xsl:when test="$eventcontent eq 'desc'">
                    <desc><xsl:value-of select="$content"/></desc>
                  </xsl:when>
                  <xsl:when test="string-length($content) &lt; 10">
                    <label><xsl:value-of select="$content"/></label>
                  </xsl:when>
                  <xsl:otherwise>
                    <desc><xsl:value-of select="$content"/></desc>
                  </xsl:otherwise>
                </xsl:choose>
              </event>
            </xsl:for-each>
          </listEvent>
        </xsl:if>
        <xsl:if test="$meta/@wikidata">
          <xsl:call-template name="list-relation">
            <xsl:with-param name="wd-id" select="$wd-idno/text()"/>
          </xsl:call-template>
        </xsl:if>
      </standOff>
    </xsl:if>
  </xsl:template>

  <xsl:template name="list-relation">
    <xsl:param name="wd-id"/>
    <listRelation>
      <relation
        name="wikidata"
        active="https://dracor.org/entity/{$meta/@id}"
        passive="http://www.wikidata.org/entity/{$wd-id}"/>
    </listRelation>
  </xsl:template>

  <!-- strip old elements  -->
  <xsl:template match="
    tei:sourceDesc//tei:bibl[@type='originalSource' or @type='firstEdition']
      /tei:date[@type='print' or  @type='premiere' or @type='written']" />
  <xsl:template match="tei:publicationStmt/tei:idno[@type='wikidata']" />
  <xsl:template match="tei:bibl[
    @type='originalSource' and
    not(*[local-name!='date'])
    and normalize-space()=''
  ]"/>
  <xsl:template match="tei:publicationStmt/tei:idno[@type='dracor']"/>
</xsl:stylesheet>
