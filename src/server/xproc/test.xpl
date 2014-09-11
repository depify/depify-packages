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

  <p:input port="source"/>
  <p:outout port="result"/>
  
  <p:import href="recursive-directory-list.xpl"/>

  <p:identity/>

</p:declare-step>
