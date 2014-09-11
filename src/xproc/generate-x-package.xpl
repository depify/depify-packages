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
    xmlns:depify="https://github.com/xquery/depify"
    name="generate-x"
    version="1.0"
    exclude-inline-prefixes="cx c p">

  <p:documentation>
    Iterates through package.xml, generating a zip archive for each
    package into /downloads directory

    @option distro_path 
    
    @returns zip archives of all packages contained in repository
  </p:documentation>

  <!-- package xml is primary input //-->
  <p:input port="source">
    <p:document href="../../../packages/package.xml"/>
  </p:input>

  <p:output port="result" sequence="true"/>

  <p:option name="distro_path" required="true"/>

  <!-- uses recursive directory listing and cx:zip extension steps //-->
  <p:import href="extension-library.xml"/>
  <p:import href="recursive-directory-list.xpl"/>

  <!-- iterate through each package //-->
  <p:for-each >
    <p:iteration-source select="/depify:depify/depify:package"/>
    <p:output port="result"/>

    <p:variable name="ppath" select="/depify:package/@path"/>
    <p:variable name="zipname" select="/depify:package/@name"/>
    <p:variable name="pname" select="tokenize(/depify:package/@name,'\.')[last()]"/>
    <p:variable name="pversion" select="/depify:package/@version"/>

    <p:in-scope-names name="pkgvars"/>

    <cx:recursive-directory-list name="list">
      <p:with-option name="path" select="concat($distro_path,$ppath)"/>
    </cx:recursive-directory-list>

    <!-- generate zip manifest for package //-->
    <p:xslt name="generate-manifest">
      <p:input port="stylesheet">
        <p:inline>
          <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                          xmlns="https://github.com/xquery/depify"
                          version="2.0">

            <xsl:param name="pname"/>
            <xsl:param name="ppath"/>
            <xsl:param name="pversion"/>

            <xsl:output method="xml" encoding="UTF8" omit-xml-declaration="yes" indent="no"/>
            <xsl:template match="/">
              <zip-manifest xmlns="http://www.w3.org/ns/xproc-step">
                <xsl:apply-templates select="//*:directory"/>
              </zip-manifest>
            </xsl:template>

            <xsl:template match="*:directory">
              <xsl:apply-templates select="*:file">
                <xsl:with-param name="base" select="@xml:base"/>
              </xsl:apply-templates>
            </xsl:template>

            <xsl:template match="*:file[@name ne '.DS_Store'][not(ends-with(@name,'.zip')) ]">
              <xsl:param name="base"/>
              <xsl:variable name="path" select="concat($pname,'-',$pversion,substring-after($base,concat($pname,'/',$pversion)))"/>
              <c:entry name="{$path}{@name}" href="{$base}/{@name}" method="stored"/>
            </xsl:template>

          </xsl:stylesheet>
        </p:inline>
      </p:input>
      <p:input port="parameters">
        <p:pipe step="pkgvars" port="result"/>
      </p:input>   
    </p:xslt>

    <!-- generate zip  //-->
    <cx:zip>
      <p:with-option name="href"
                     select="concat($distro_path,'/downloads/',$zipname,'-',$pversion,'.zip')"/>
      <p:input port="manifest">
        <p:pipe step="generate-manifest" port="result"/>
      </p:input>
    </cx:zip>

  </p:for-each>

  <!-- run pipeline manually in emacs with m-x compile //-->
  <p:documentation>
    (:
    -- Local Variables:
    -- compile-command: "/usr/local/bin/calabash  -oresult=output.xml generate-x-package.xpl distro_path=file:///Users/jfuller/Source/Webcomposite/depify/"
    -- End:
    :)
  </p:documentation>

</p:declare-step>
