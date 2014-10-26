<?xml version="1.0" encoding="UTF-8"?>
<!--
  Copyright (c) 2011-2012 James Fuller

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
//-->
<p:declare-step 
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:cx="http://xmlcalabash.com/ns/extensions"
    name="generate-package"
    version="1.0"
    exclude-inline-prefixes="cx c p">

  <p:documentation>
    Generates main package bom for entire depx repository.
  </p:documentation>

  <p:output port="result">
    <p:pipe step="aggregate" port="result"/>
  </p:output>

  <p:documentation>generate package xml from packages directories</p:documentation>
  
  <p:import href="recursive-directory-list.xpl"/>

  <cx:recursive-directory-list name="list">
    <p:with-option name="path" select="'../../packages'"/>
  </cx:recursive-directory-list>


  <p:for-each name="loop">
    <p:output port="result" sequence="true"/>
    <p:iteration-source select="//c:file[ends-with(@name,'.depify.xml')]"/>
    <p:variable name="file" select="/c:file/@name"/>
    <p:validate-with-relaxng assert-valid="true">
      <p:input port="schema">
        <p:document href="relaxngschema.rng"/>
      </p:input>
    </p:validate-with-relaxng>
    <p:load name="file">
      <p:with-option name="href" select="$file"/>
    </p:load>
  </for-each>
  <p:wrap-sequence wrapper="packages" wrapper-namespace="https://github.com/depify"/>

    
  <!--p:xslt name="aggregate">
    <p:input port="stylesheet">
      <p:inline>
        <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns="https://github.com/depify"
                        version="2.0">
          <xsl:output method="xml" encoding="UTF8" omit-xml-declaration="yes" indent="no"/>

          <xsl:template match="/">
            <depify ts="{current-dateTime()}">
              <xsl:apply-templates select="//*:directory"/>
            </depify>
          </xsl:template>

          <xsl:template match="*:directory">
              <xsl:apply-templates select="*:file">
                <xsl:with-param name="base" select="@xml:base"/>
              </xsl:apply-templates>
          </xsl:template>

          <xsl:template match="*:file[@name eq '.depify.xml']">
            <xsl:param name="base"/>
            <xsl:variable name="package" select="doc(concat($base,'.depify.xml'))"/>
            <xsl:element name="dep">
              <xsl:attribute name="path" select="concat('/packages/',substring-after($base,'/packages/'))"/>
              <xsl:copy-of select="$package/*/@*"/>
              <xsl:copy-of select="$package/*/*"/>
            </xsl:element>
          </xsl:template>
        </xsl:stylesheet>
      </p:inline>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>   
  </p:xslt-->


</p:declare-step>
