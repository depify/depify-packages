<?xml version="1.0" encoding="UTF-8"?>
<!--
  Copyright (c) 2014 James Fuller

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
    xmlns:depify="https://github.com/depify"
    name="generate-package"
    version="1.0"
    exclude-inline-prefixes="cx c p">

  <p:documentation>
    Generates main package bom for entire depify repository.
  </p:documentation>

  <p:output port="result">
    <p:pipe step="aggregate" port="result"/>
  </p:output>

  <p:documentation>generate package xml from packages directories</p:documentation>

  <p:import href="extension-library.xml"/>  
  <p:import href="recursive-directory-list.xpl"/>

  <cx:recursive-directory-list name="list">
    <p:with-option name="path" select="'../../packages'"/>
  </cx:recursive-directory-list>

  <p:for-each name="loop">
    <p:output port="result" sequence="true"/>
    <p:iteration-source select="//c:file[ends-with(@name,'.depify.xml')]"/>
    <p:variable name="file" select="concat(base-uri(c:file),/c:file/@name)"/>
    <p:load name="file">
      <p:with-option name="href" select="$file"/>
    </p:load>
    
    <cx:message>
      <p:with-option name="message" select="concat('processing ',/depify:depify/@name,' ',/depify:depify/@version)"/>
    </cx:message>

    <p:choose>
      <p:when test="/depify:depify/@keep-fresh eq 'true'">
        <p:variable name="keep-fresh-repo-version" select="concat('https://raw.githubusercontent.com',substring-after(/depify:depify/@repo-uri,'https://github.com'),'/',@version,'/.depify.xml')"/>
        <p:variable name="keep-fresh-repo-master" select="concat('https://raw.githubusercontent.com',substring-after(/depify:depify/@repo-uri,'https://github.com'),'/master/.depify.xml')"/>
        <cx:message>
          <p:with-option name="message" select="concat('keep-fresh enabled, downloading from ',$keep-fresh-repo-version)"/>
        </cx:message>    
        <p:load>
          <p:with-option name="href" select="if(doc-available($keep-fresh-repo-version)) then $keep-fresh-repo-version else $keep-fresh-repo-master"/>
    </p:load>
      </p:when>
    <p:otherwise>
      <p:identity/>
    </p:otherwise>
    </p:choose>
     <p:validate-with-relax-ng assert-valid="true">
      <p:input port="schema">
        <p:document href="../../etc/depify.rng"/>
      </p:input>
    </p:validate-with-relax-ng>
    <p:add-attribute attribute-name="path" match="/depify:depify">
      <p:with-option name="attribute-value" select="substring-after($file,'depify-packages')"/>
    </p:add-attribute>

  </p:for-each>
  <p:wrap-sequence wrapper="packages" wrapper-namespace="https://github.com/depify"/>
  <p:add-attribute name="aggregate" attribute-name="ts" match="/depify:packages">
    <p:with-option name="attribute-value" select="current-dateTime()"/>
  </p:add-attribute>
    
</p:declare-step>
