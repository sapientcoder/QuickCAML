<%@ Page Language="C#" masterpagefile="~masterurl/default.master" title="QuickCAML" inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" meta:progid="SharePoint.WebPartPage.Document" meta:webpartpageexpansion="full" %>
<%@ Register tagprefix="SharePoint" namespace="Microsoft.SharePoint.WebControls" assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<asp:Content ContentPlaceHolderID="PlaceHolderPageTitle" runat="server">
QuickCAML - The quick way to test your CAML queries!
</asp:Content>

<asp:Content ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea" runat="server">
QuickCAML - v0.5 (BETA)
</asp:Content>

<asp:Content ContentPlaceHolderID="PlaceHolderAdditionalPageHead" runat="server">

<SharePoint:ScriptLink Name="sp.js" LoadAfterUI="True" Localizable="False" OnDemand="False" runat="server"></SharePoint:ScriptLink>

<style type="text/css">
	.intro { margin-bottom: 20px; }
	.section { margin-bottom: 20px; }
	.section-header { padding-bottom: 6px; border-bottom: #ddd 1px solid; }
	.section-header h3 {}
	.section-content { margin: 15px 0 0 10px; }
	.field-row { overflow: hidden; margin-bottom: 10px; }
	.field-row label { float: left; width: 10%; }
	.field-container { float: left; width: 90%; }
	.loading-lists { margin-left: 6px; vertical-align: middle; width: 16px; height: 16px; }
	label.disabled { color: #999; }
	#siteUrl { width: 300px; }
	#camlEditor { width: 600px; height: 300px; border: 1px solid #ccc; }
	#rowLimit { width: 50px; }
	#calendarDate { width: 150px; }
	#folderUrl { width: 300px; }
	#queryOptions label { float: none; vertical-align: middle; }
	#execButton { float: left; margin-left: 10% !important; margin-top: 10px !important; padding: 7px 14px; }
	.executing-query { margin-left: 6px; margin-top: 15px; width: 16px; height: 16px; }
	#tabularDataWrapper { overflow: auto; max-height: 500px; }
	#tabularData { border: 0; }
	#tabularData th { background-color: #eee; text-align: left; padding: 6px 8px 6px 0; }
	#tabularData td { text-align: left; padding: 2px 8px 2px 0; }
	#tabularData tr.alternate td { background-color: #eee; }
	#output { width: 600px; height: 150px; margin-left: 0 !important; }
</style>

<script type="text/javascript">
	document.write("<link rel='stylesheet' href='//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css'></link>");
</script>
	
</asp:Content>

<asp:Content ContentPlaceHolderID="PlaceHolderMain" runat="server">

<script type="text/javascript">
	window.jQuery || document.write("<script src='//code.jquery.com/jquery-1.11.2.min.js'>\x3C/script>");
	document.write("<script src='//code.jquery.com/ui/1.11.2/jquery-ui.min.js'>\x3C/script>");
	document.write("<script src='//cdnjs.cloudflare.com/ajax/libs/knockout/3.2.0/knockout-min.js'>\x3C/script>");
	document.write("<script src='//cdn.jsdelivr.net/ace/1.1.8/min/ace.js'>\x3C/script>");
	document.write("<script src='//cdn.jsdelivr.net/ace/1.1.8/min/ext-language_tools.js'>\x3C/script>");
</script>

<p class="intro">
QuickCAML lets you test CAML queries quickly and easily right from your browser! Simply choose a list, define your query and options,
and click the Execute button. You can also change sites within this site collection by changing the Site Url below.
<br /><br />
For help or feedback, please visit the QuickCAML GitHub page at <a href="https://github.com/inclinetechnical/QuickCAML" target="_new">https://github.com/inclinetechnical/QuickCAML</a>.
Use the "Issues" tab on the GitHub page to report issues or request features.
</p>


<p style="color:red; display:none;" data-bind="visible: ( scriptError )">
	An unexpected script error has occurred: <span data-bind="text: scriptError()"></span>
	<br /><br />
	Check your browser&#39;s JavaScript debugging tools for more details.
</p>

<div class="section-wrapper">
	<div class="section" id="query-section" data-bind="visible: (visibleSectionId() === 'query-section')">
		<div class="section-header">
			<h3>Query Definition</h3>
		</div>
		<div class="section-content">
			<p>
				<a href="" data-bind="click: function() { visibleSectionId('results-section'); }, visible: (queryResult)" style="display: none;">
				View most recent results &raquo;</a>
			</p>
			<div id="queryDefForm">
				<div class="field-row">
					<label for="list">Site Url:</label>
					<div class="field-container">
						<div data-bind="visible: !editingSiteUrl()"><span data-bind="text: siteUrl"></span> [<a href="" data-bind="click: changeSiteUrl">change</a>]</div>
						<div data-bind="visible: editingSiteUrl" style="display: none;">
							<input type="text" id="siteUrl" name="siteUrl" data-bind="value: tempSiteUrl" />
							[<a href="" data-bind="click: saveSiteUrl">save</a> | <a href="" data-bind="click: function() { editingSiteUrl(false); }">cancel</a>]
						</div>
					</div>
				</div>
				<div class="field-row">
					<label for="list">List or library:</label>
					<div class="field-container">
						<select id="list" name="list" data-bind="visible: (lists().length &gt; 0), options: lists, value: selectedList, optionsCaption: 'Choose a list...'" style="display: none;"></select>
						<img src="/_layouts/15/images/gears_anv4.gif" class="loading-lists" data-bind="visible: loadingLists" alt="Loading lists..." />
					</div>
				</div>
				<div class="field-row" data-bind="visible: (selectedList)" style="display: none;">
					<label for="camlEditor">Query (CAML):</label>
					<div class="field-container">
						<div id="camlEditor" data-bind="aceText: camlQuery"></div>
					</div>
				</div>
				<div class="field-row" data-bind="visible: (selectedList)" style="display: none;">
					<label for="rowLimit">Row limit:</label>
					<div class="field-container">
						<input type="text" id="rowLimit" name="rowLimit" data-bind="value: rowLimit" />
					</div>
				</div>
				<div class="field-row" data-bind="visible: (selectedList)" style="display: none;">
					<label for="calendarDate">Calendar date:</label>
					<div class="field-container">
						<input type="text" id="calendarDate" name="calendarDate" data-bind="value: calendarDate, disable: mustUseJsom" />
					</div>
				</div>
				<div class="field-row" data-bind="visible: (selectedList)" style="display: none;">
					<label for="folderUrl">Folder Url:</label>
					<div class="field-container">
						<input type="text" id="folderUrl" name="folderUrl" data-bind="value: folderUrl" />
					</div>
				</div>			
				<div class="field-row" data-bind="visible: (selectedList)" style="display: none;">
					<label for="queryOptions">Query options:</label>
					<div id="queryOptions" class="field-container">
						<div class="horiz-option">
							<input type="checkbox" id="datesInUtc" name="datesInUtc" data-bind="checked: datesInUtc" />
							<label for="datesInUtc">Dates in UTC</label>
						</div>
						<div class="horiz-option">
							<input type="checkbox" id="expandRecurrence" name="expandRecurrence" data-bind="checked: expandRecurrence, disable: mustUseJsom" />
							<label for="expandRecurrence" data-bind="css: { disabled: mustUseJsom }">
							Expand Recurrence</label>
						</div>
						<div class="horiz-option">
							<input type="checkbox" id="expanduserField" name="expandUserField" data-bind="checked: expandUserField, disable: mustUseJsom" />
							<label for="expandUserField" data-bind="css: { disabled: mustUseJsom }">
							Expand User Field</label>
						</div>
						<div class="horiz-option">
							<input type="checkbox" id="includeAttachmentUrls" name="includeAttachmentUrls" data-bind="checked: includeAttachmentUrls, disable: mustUseJsom" />
							<label for="includeAttachmentUrls" data-bind="css: { disabled: mustUseJsom }">
							Include Attachment URLs</label>
						</div>
						<div class="horiz-option">
							<input type="checkbox" id="includeAttachmentVersion" name="includeAttachmentVersion" data-bind="checked: includeAttachmentVersion, disable: mustUseJsom" />
							<label for="includeAttachmentVersion" data-bind="css: { disabled: mustUseJsom }">
							Include Attachment Version</label>
						</div>
						<div class="horiz-option">
							<input type="checkbox" id="includeMandatoryFields" name="includeMandatoryFields" data-bind="checked: includeMandatoryFields, disable: mustUseJsom" />
							<label for="includeMandatoryFields" data-bind="css: { disabled: mustUseJsom }">
							Include Mandatory Fields</label>
						</div>
						<div class="horiz-option">
							<input type="checkbox" id="includePermissions" name="includePermissions" data-bind="checked: includePermissions, disable: mustUseJsom" />
							<label for="includePermissions" data-bind="css: { disabled: mustUseJsom }">
							Include Permissions</label>
						</div>
						<div class="horiz-option">
							<input type="checkbox" id="recurrenceOrderBy" name="recurrenceOrderBy" data-bind="checked: recurrenceOrderBy, disable: mustUseJsom" />
							<label for="recurrenceOrderBy" data-bind="css: { disabled: mustUseJsom }">
							Recurrence Order-By</label>
						</div>
					</div>
				</div>
				<div class="field-row" data-bind="visible: (selectedList)" style="display: none;">
					<button id="execButton" data-bind="click: executeQuery, enable: canExecute">
					Execute</button>
					<img src="/_layouts/15/images/gears_anv4.gif" class="executing-query" data-bind="visible: executingQuery" alt="Executing query..." />
				</div>
			</div>
		</div>
	</div>

	<div class="section" id="results-section" data-bind="visible: (visibleSectionId() === 'results-section')" style="display:none;">
		<div class="section-header">
			<h3>Query Results</h3>
		</div>
		<div class="section-content">
			<p>
				<a href="" data-bind="click: function() { visibleSectionId('query-section'); }">
				&laquo; Back to query definition</a>
			</p>
			<div data-bind="with: queryResult">
				<p style="line-height: 20px;">
					<strong>Query API:</strong> <span data-bind="text: api"></span> <br />
					<strong>Query Result:</strong> <span data-bind="text: apiResult"></span><br />
					<strong>Item Count:</strong> <span data-bind="text: tabularData.rows.length"></span> <span data-bind="visible: (nextPage || currentPage &gt; 1)">(for this page)</span>
				</p>
				
				<p style="height: 25px;" data-bind="visible: (nextPage || currentPage &gt; 1)">
					[Page <span data-bind="text: currentPage"></span>]
					<a href="" data-bind="disable: $parent.executingQuery, visible: (nextPage), click: $parent.goToNextPage">Next &raquo;</a>
					<img src="/_layouts/15/images/gears_anv4.gif" style="margin-top: 0 !important; vertical-align: middle;" class="executing-query" data-bind="visible: $parent.executingQuery" alt="Executing query..." />
				</p>
				
				<p style="color: red;" data-bind="visible: (error)">
					<span data-bind="text: error"></span>
				</p>

				<div data-bind="visible: (!error)">
					<div id="tabularDataWrapper">
						<table id="tabularData" cellpadding="0" cellspacing="0">
							<thead>
								<tr data-bind="foreach: tabularData.headers">
									<th><span data-bind="text: $data"></span></th>
								</tr>
							</thead>
							<tbody data-bind="foreach: tabularData.rows">
								<tr data-bind="foreach: $data, css: { alternate: $index() % 2 }">
									<td><span data-bind="text: $data"></span></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				
				<!-- Uncommend the line below to view raw output from the ASMX web service API. Not used with JSOM API. -->
				<!-- <textarea id="output" name="output" data-bind="visible: (rawResult), value: rawResult"></textarea> -->
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	/**
	 * CAML intellisense completer for ACE Editor plug-in.
	 **/
	function CamlCompleter() {
		var self = this;
		var ti = ace.require('ace/token_iterator');

		var logicAndComparisonTags = [
			'and', 'beginswith', 'contains', 'daterangesoverlap', 'eq', 'geq', 'gt',
			'in', 'includes', 'isnotnull', 'isnull', 'leq', 'lt', 'membership',
			'neq', 'notincludes', 'or'
		];

		// Define a tag map that we can use for generating reasonably intelligent
		// intellisense suggestions (that are contextual but aren't strictly
		// validated against a language grammar or XSD).
		var	camlTags = {
			'and' : { tag: 'And', children: logicAndComparisonTags },
			'beginswith': { tag: 'BeginsWith', children: [ 'fieldref', 'value', 'xml' ] },
			'contains' : { tag: 'Contains', children: [ 'fieldref', 'value', 'xml' ] },
			'daterangesoverlap' : { tag: 'DateRangesOverlap', children: [ 'fieldref', 'value' ] },
			'eq' : { tag: 'Eq', children: [ 'fieldref', 'value', 'xml' ] },
			'field' : { tag: 'Field', attrs: { 'name' : { name: 'Name' }, 'type' : { name: 'Type', values: 'Lookup' }, 'list' : { name: 'List' }, 'showfield' : { name: 'ShowField' } } },
			'fieldref' : { tag: 'FieldRef', attrs: { 'name' : { name : 'Name', values: '{fields}' }, 'list' : { name: 'List' }, 'lookupid' : { name: 'LookupId', values: 'TRUE|FALSE' }, 'reftype' : { name: 'RefType', values: 'Id' } } },
			'geq' : { tag: 'Geq', children: [ 'fieldref', 'value', 'xml' ] },
			'groupby' : { tag: 'GroupBy', children: [ 'fieldref' ], attrs: { 'collapse' : { name : 'Collapse', values: 'TRUE|FALSE' } } },
			'gt' : { tag: 'Gt', children: [ 'fieldref', 'value', 'xml' ] },
			'in' : { tag: 'In', children: [ 'fieldref', 'values' ] },
			'includes' : { tag: 'Includes', children: [ 'fieldref', 'value', 'xml' ] },
			'isnotnull' : { tag: 'IsNotNull', children: [ 'fieldref' ] },
			'isnull' : { tag: 'IsNull', children: [ 'fieldref' ] },
			'joins' : { tag: 'Joins', children: [ 'join' ] },
			'join' : { tag: 'Join', children: [ 'eq' ], attrs: { 'type' : { name: 'Type', values: 'LEFT' }, 'listalias' : { name: 'ListAlias' } } },
			'leq' : { tag: 'Leq', children: [ 'fieldref', 'value', 'xml' ] },
			'listproperty' : { tag: 'ListProperty' },
			'lt' : { tag: 'Lt', children: [ 'fieldref', 'value', 'xml' ] },
			'membership' : { tag: 'Membership', children: [ 'fieldref' ], attrs: { 'type' : { name : 'Type', values : 'SPWeb.AllUsers|SPGroup|SPWeb.Groups|CurrentUserGroups|SPWeb.Users' } } },
			'month' : { tag: 'Month' },
			'neq' : { tag: 'Neq', children: [ 'fieldref', 'value', 'xml' ] },
			'notincludes' : { tag: 'NotIncludes', children: [ 'fieldref', 'value', 'xml' ] },
			'now' : { tag: 'Now' },
			'or' : { tag: 'Or', children: logicAndComparisonTags },
			'orderby' : { tag: 'OrderBy', children: [ 'fieldref' ], attrs: { 'override' : { name : 'Override', values : 'TRUE|FALSE' }, 'useindexfororderby' : { name : 'UseIndexForOrderBy', values : 'TRUE|FALSE'} } },
			'projectedfields' : { tag: 'ProjectedFields', children: [ 'field' ] },
			'query' : { tag: 'Query', children: [ 'where' ] },
			'today' : { tag: 'Today', attrs: { 'offset' : { name : 'Offset' } } },
			'userid' : { tag: 'UserID' },
			'value' : { tag: 'Value', children: [ 'listproperty', 'month', 'now', 'today', 'userid', 'xml' ], attrs: { 'type' : { name : 'Type', values: 'Boolean|DateTime|Integer|Lookup|Number|Text' }, 'includetimevalue' : { name : 'IncludeTimeValue', values : 'TRUE|FALSE' } } },
			'values' : { tag: 'Values', children: [ 'value' ] },
			'view' : { tag: 'View', children: [ 'joins', 'projectedfields', 'query', 'viewfields' ], attrs: { 'scope' : { name : 'Scope', values : 'FilesOnly|Recursive|RecursiveAll' } } },
			'viewfields' : { tag: 'ViewFields', children: [ 'fieldref' ] },
			'where' : { tag: 'Where', children: logicAndComparisonTags.concat('orderby') },
			'xml' : { tag: 'XML' }
		};
		
		// Private classes
		
		var Tag = function() {
		    this.tagName = "";
		    this.closing = false;
		    this.selfClosing = false;
		    this.start = {row: 0, column: 0};
		    this.end = {row: 0, column: 0};
		};
		
		// Private functions
	
		function findAttributeName(session, pos) {
			var tokenIterator = new ti.TokenIterator(session, pos.row, pos.column);
		    var token = tokenIterator.getCurrentToken();
		    while (token && !is(token, "attribute-name")){
		        token = tokenIterator.stepBackward();
		    }
		    if (token)
		        return token.value;
		}

		function findTagName(session, pos) {
			var tokenIterator = new ti.TokenIterator(session, pos.row, pos.column);
		    var token = tokenIterator.getCurrentToken();
		    while (token && !is(token, "tag-name")){
		        token = tokenIterator.stepBackward();
		    }
		    if (token)
		        return token.value;
		}

		function readTagBackward(iterator) {
		    var token = iterator.getCurrentToken();
		    if (!token)
		        return null;
		
		    var tag = new Tag();
		    do {
		        if (is(token, "tag-open")) {
		            tag.closing = is(token, "end-tag-open");
		            tag.start.row = iterator.getCurrentTokenRow();
		            tag.start.column = iterator.getCurrentTokenColumn();
		            iterator.stepBackward();
		            return tag;
		        } else if (is(token, "tag-name")) {
		            tag.tagName = token.value;
		        } else if (is(token, "tag-close")) {
		            tag.selfClosing = token.value == "/>";
		            tag.end.row = iterator.getCurrentTokenRow();
		            tag.end.column = iterator.getCurrentTokenColumn() + token.value.length;
		        }
		    } while(token = iterator.stepBackward());
		
		    return null;
		};

		function findParentTagName(editor, session, pos) {
			var tokenIterator = new ti.TokenIterator(session, pos.row, pos.column);
			var skip = 0;
			var tag;
			while (tag = readTagBackward(tokenIterator)) {
				if (tag.closing)
					skip++;
				if (!tag.selfClosing && !tag.closing && tag.tagName) {
					if (skip > 0)
						skip--;
					else
						break;
				}
			}
			return (tag ? tag.tagName : null);
		}

		function is(token, type) {
		    return token.type.lastIndexOf(type + ".xml") > -1;
		}
		
		// Editor-accessible properties & functions
		
		// defines additional characters that trigger intellisense
		self.identifierRegexps = [/[<\s"]/];
		
		// function that feeds intellisense suggestions to ACE autocomplete popup
		self.getCompletions = function(editor, session, pos, prefix, callback) {
			var token = session.getTokenAt(pos.row, pos.column);
			var result = [];
			
	        if (is(token, "tag-name") || is(token, "tag-open") || is(token, "end-tag-open")) {
	        	// Offer context-appropriate tag suggestions based on parent tag "above" cursor position
	        	var tagName = findParentTagName(editor, session, pos);
	        	var tag;
	        	if (tagName) {
	        		tag = camlTags[tagName.toLowerCase()];
	        		if (tag && tag.children) {
	        			var tagResult = [];
	        			jQuery.each(tag.children, function(idx, child) {
	        				var childTag = camlTags[child];
	        				if (childTag) {
								tagResult.push({
									caption: childTag.tag,
									value: childTag.tag,
									meta: 'CAML' // indicates this suggestions is a CAML tag
								});
	        				}
	        			});
	        			result = tagResult;
	        		}
	        	}
	        	else {
	        		// no parent tag found; assume cursor is in outer-most level of
	        		// CAML text and offer "View" tag (root tag) as a suggestion
	        		tag = camlTags['view'];
	        		result = [{
	        			caption: tag.tag,
	        			value: tag.tag,
	        			meta: 'CAML'
	        		}];
	        	}
	        }
	        else if (is(token, "tag-whitespace") || is(token, "attribute-name")) {
	        	// Offer attribute suggestions
				var tagName = findTagName(session, pos);
				if (tagName) {
					var tag = camlTags[tagName.toLowerCase()];
					if (tag && tag.attrs) {
						var attrResult = [];
						jQuery.each(tag.attrs, function(idx, attr) {
							attrResult.push({
								caption: attr.name,
								value: attr.name,
								snippet: attr.name + '="$0"',
								meta: 'attribute' // indicates this suggestions is a CAML tag attribute
							});
						});
						result = attrResult;
					}
				}
			}
			else if (is(token, "attribute-value")) {
				// Offer attribute value suggestions
				var attrName = findAttributeName(session, pos);
				var tagName = findTagName(session, pos);
				if (attrName && tagName) {
					var tag = camlTags[tagName.toLowerCase()];
					if (tag.attrs) {
						var attr = tag.attrs[attrName.toLowerCase()];
						if (attr && attr.values) {
							if (attr.values === '{fields}') {
								var fields = jQuery('#list').data('fields');
								if (fields) {
									result = jQuery.map(fields, function(fld) {
										return {
											caption: fld.title,
											value: fld.title,
											snippet: fld.name,
											meta: fld.name // in this case, meta (right-hand column on popup) is internal field name
										};
									});
								}
							}
							else {
								result = jQuery.map(attr.values.split('|'), function(val) {
									return {
										caption: val,
										value: val
									};
								});
							}
						}
					}
				}
			}
			
			callback(null, result);
		};
	}

	/**
	 * View-model for Knockout JS bindings.
	 **/
	function QuickCAMLViewModel(ctx) {
		var self = this;
		var _siteUrl = ko.observable();
		var _selectedList = ko.observable();
		var listFolders = {};

		var Constants = {
			DefaultCamlQuery  : '<View>\n    <Query>\n        <Where>\n        </Where>\n    </Query>\n    <ViewFields>\n    </ViewFields>\n</View>',
			ErrorPrefixRegex  : /^Error:\s*/i,
			FieldNameRegex    : /Name=(?:"(\w+)"|'(\w+)')/ig,
			ListServiceUrl    : '/_vti_bin/lists.asmx',
			JoinXmlRegex      : /<Joins>(?:.|\s)*<\/Joins>/i,
			ProjectedFldRegex : /<ProjectedFields>(?:.|\s)*<\/ProjectedFields>/i,
			SoapEnvStart      : '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><GetListItems xmlns="http://schemas.microsoft.com/sharepoint/soap/">',
			SoapEnvEnd        : '</GetListItems></soapenv:Body></soapenv:Envelope>',
			QueryXmlRegex     : /<Query>(?:.|\s)*<\/Query>/i,
			ViewFieldXmlRegex : /<ViewFields>(?:.|\s)*<\/ViewFields>/i,
			ViewStartTagRegex : /<View[\w\s="]*>/,
			XmlAttrRegex      : /\w+=["']\w+['"]/g
		};
		
		// Bindable properties

		self.siteUrl = ko.observable(ctx.get_url());
		self.tempSiteUrl = ko.observable();
		self.editingSiteUrl = ko.observable(false);
		self.loadingLists = ko.observable(false);
		self.lists = ko.observableArray([]);
		
		self.selectedList = ko.computed({
			read: function() {
				return _selectedList();
			},
			write: function(value) {
				_selectedList(value);
				if (listFolders[value])
					self.folderUrl(listFolders[value]);
				if (!self.camlQuery())
					self.camlQuery(Constants.DefaultCamlQuery);
				// silently fetch list fields to use later with intellisense
				updateListFields();
			}
		});
		
		// catch-all for unexpected script errors
		self.scriptError = ko.observable();
		
		// main query properties
		self.camlQuery = ko.observable();
		self.rowLimit = ko.observable(50);
		self.calendarDate = ko.observable();
		self.folderUrl = ko.observable();
		
		// query options
		self.datesInUtc = ko.observable(false);
		self.expandRecurrence = ko.observable(false);
		self.expandUserField = ko.observable(false);
		self.includeAttachmentUrls = ko.observable(false);
		self.includeAttachmentVersion = ko.observable(false);
		self.includeMandatoryFields = ko.observable(false);
		self.includePermissions = ko.observable(false);
		self.recurrenceOrderBy = ko.observable(false);
		
		// miscellaneous properties
		self.visibleSectionId = ko.observable('query-section');
		
		// indicates whether JavaScript OM must be used (a requirement to support certain CAML queries
		// that aren't supported by the ASMX web services)
		self.mustUseJsom = ko.pureComputed(function() {
			return ( joinXml() || projectedFldXml() );
		});

		self.canExecute = ko.pureComputed(function() {
			return !self.executingQuery();
		});
		
		self.executingQuery = ko.observable(false);
		self.rawResult = ko.observable('');
		self.queryResult = ko.observable(null);
		
		// Bindable functions
		
		self.changeSiteUrl = function() {
			self.tempSiteUrl(self.siteUrl());
			self.editingSiteUrl(true);
		}
		
		self.saveSiteUrl = function() {
			self.editingSiteUrl(false);
			self.siteUrl(self.tempSiteUrl());
			fetchLists();
		}
		
		self.executeQuery = function(obj1, obj2, page) {
			// execute query using appropriate API
			// obj1 & obj2 are passed in by Knockout JS in certain cases and are ignored
			try {
				if (self.mustUseJsom()) {
					executeQueryWithJsom(page);
				}
				else {
					executeQueryWithAsmx(page);
				}
			}
			catch (ex) {
				self.executingQuery(false);
				self.scriptError(ex);
				throw ex;
			}
		};
		
		self.goToNextPage = function() {
			if (!self.executingQuery())
				self.executeQuery(null, null, 'next');
		};
		
		// Private observable properties
		
		// extracts <Query> element from CAML text
		var queryXml = ko.pureComputed(function() {
			return (Constants.QueryXmlRegex.exec(self.camlQuery()) || [''])[0];
		});
		
		// extracts <Joins> element from CAML text
		var joinXml = ko.pureComputed(function() {
			return (Constants.JoinXmlRegex.exec(self.camlQuery()) || [''])[0];
		});

		// extracts <ProjectedFields> element from CAML text
		var projectedFldXml = ko.pureComputed(function() {
			return (Constants.ProjectedFldRegex.exec(self.camlQuery()) || [''])[0];
		});
		
		// extracts <ViewFields> element from CAML text
		var viewFieldXml = ko.pureComputed(function() {
			return (Constants.ViewFieldXmlRegex.exec(self.camlQuery()) || [''])[0];
		});
		
		// extracts view attributes from <View> tag in CAML text
		var viewAttributes = ko.pureComputed(function() {
			// Not sure about JSOM, but the ASMX web service treats view attributes (names and values) as case-sensitive.
			// Therefore, for well-known attributes like 'Scope', we ensure proper case. Any other attribute names
			// and values in the <View> tag are passed along exactly as entered by the user.
			var viewAttrs = '';
			var viewStartTag = Constants.ViewStartTagRegex.exec(self.camlQuery());
			if (viewStartTag) {
				var attrs;
				while (attrs = Constants.XmlAttrRegex.exec(viewStartTag[0])) {
					for (var i = 0; i < attrs.length; i++) {
						if (attrs[i]) {
							var parts = attrs[i].split('=');
							if (parts.length == 2) {
								var val = parts[0] || '';
								if (val.toLowerCase() === 'scope') {
									switch (removeQuotes(parts[1] || '').toLowerCase()) {
										case 'filesonly':
											viewAttrs += 'Scope="FilesOnly" ';
											break;
										case 'recursive':
											viewAttrs += 'Scope="Recursive" ';
											break;
										case 'recursiveall':
											viewAttrs += 'Scope="RecursiveAll" ';
											break;
										default:
											break;
									}
								}
								else {
									viewAttrs += val + '="' + removeQuotes(parts[1]) + '" ';
								}
							}
						}
					}
				}
			}
			return viewAttrs;
		});

		// gets the view XML used for JavaScript CSOM (JSOM) calls
		var viewXml = ko.pureComputed(function() {
			var view = '<View';
			var viewAttrs = viewAttributes();
			var query = queryXml();
			var viewFields = viewFieldXml();
			var joins = joinXml();
			var projFields = projectedFldXml();
			
			if (viewAttrs)
				view += ' ' + viewAttrs;
			view += '>';
			if (query)
				view += query;
			if (joins)
				view += joins;
			if (projFields)
				view += projFields;
			if (viewFields)
				view += viewFields;
			// for JSOM, row limit must be passed in using a tag
			view += '<RowLimit>' + self.rowLimit() + '</RowLimit>';
			view +='</View>';
			
			return view;
		});
		
		// Private functions and classes
		
		var ApiNames = {
			JsomApi : 'JavaScript Object Model (JSOM)',
			AsmxApi : 'Lists Web Service'
		};
		
		function xmlEncode(input) {
			return (input || '')
					.replace(/&/g, '&amp;')
		            .replace(/</g, '&lt;')
		            .replace(/>/g, '&gt;')
		            .replace(/"/g, '&quot;')
		            .replace(/'/g, '&apos;');
		}
		
		function getQueryOptionsXml(page) {
			var paging = '';
			if (page === 'next' && self.queryResult().nextPage) {
				paging = '<Paging ListItemCollectionPositionNext="' + xmlEncode(self.queryResult().nextPage) + '" />';
			}
		
			var xml =
				'<QueryOptions>' +
					'<CalendarDate>' + (self.calendarDate() ? new Date(self.calendarDate()).toISOString() : '') + '</CalendarDate>' +
					'<DateInUtc>' + self.datesInUtc().toString().toUpperCase() + '</DateInUtc>' +
					'<ExpandRecurrence>' + self.expandRecurrence().toString().toUpperCase() + '</ExpandRecurrence>' +
					'<ExpandUserField>' + self.expandUserField().toString().toUpperCase() + '</ExpandUserField>' +
					'<Folder>' + (self.folderUrl() || '') + '</Folder>' +
					'<IncludeAttachmentUrls>' + self.includeAttachmentUrls().toString().toUpperCase() + '</IncludeAttachmentUrls>' +
					'<IncludeAttachmentVersion>' + self.includeAttachmentVersion().toString().toUpperCase() + '</IncludeAttachmentVersion>' +
					'<IncludeMandatoryColumns>' + self.includeMandatoryFields().toString().toUpperCase() + '</IncludeMandatoryColumns>' +
					'<IncludePermissions>' + self.includePermissions().toString().toUpperCase() + '</IncludePermissions>' +
					paging +
					'<RecurrenceOrderBy>' + self.recurrenceOrderBy().toString().toUpperCase() + '</RecurrenceOrderBy>' +
					'<RecurrencePatternXMLVersion>v3</RecurrencePatternXMLVersion>' +
					'<ViewAttributes ' + viewAttributes() +'/>' +
				'</QueryOptions>';
			return xml;
		}
		
		function QueryResult(parent, api, result, error, pageNum) {
			var self = this;
			
			var Constants = {
				PathToFaultString : 'soap:Envelope > soap:Body > soap:Fault > faultstring > #text',
				PathToFaultDetail : 'soap:Envelope > soap:Body > soap:Fault > detail > errorstring > #text',
				PathToRsData      : 'soap:Envelope > soap:Body > GetListItemsResponse > GetListItemsResult > listitems > rs:data',
				ApiResultSuccess  : 'Succeeded',
				ApiResultFailure  : 'Failed'
			};
			
			self.api = api || '(unknown)';
			self.apiResult = (error ? Constants.ApiResultFailure : Constants.ApiResultSuccess);
			self.error = (error ? ensureCharAtEnd(error, '.') : null);
			self.rawResult = result.rawData;
			self.currentPage = (pageNum || 1);
			self.nextPage = '';
			self.tabularData = { headers: [], rows: [] };
			
			if (self.api === ApiNames.AsmxApi) {
				if (result.httpStatus)
					self.apiResult += ', HTTP Status = ' + result.httpStatus;
				if (result.httpStatusText)
					self.apiResult += ' ' + result.httpStatusText;
			}
			
			if (self.api === ApiNames.AsmxApi && result.xml) {
				var obj = xmlToJson(result.xml);
				
				if (!(self.error)) {
					// Successful ASMX result. Convert object created from XML above into
					// tabular data for display.
					var rsData = getObjectValue(obj, Constants.PathToRsData);
					if (rsData) {
						if (rsData['@attributes'] && rsData['@attributes']['ListItemCollectionPositionNext'])
							self.nextPage = rsData['@attributes']['ListItemCollectionPositionNext'];
						var zRows = rsData['z:row'];
						if (zRows) {
							// Do first pass to get table headers (ASMX leaves an attribute off an item entirely if the
							// attribute has no value, so we have to process all items to get the total set of attributes
							// which become our table headers).
							var headers = {};
							jQuery.each(jQuery.isArray(zRows) ? zRows : [zRows], function(idx, zRow) {
								var attrs = zRow['@attributes'];
								if (attrs) {
									jQuery.each(attrs, function(key, attr) {
										if (!headers[key]) {
											headers[key] = 1;
											self.tabularData.headers.push(key.replace(/^ows_/, ''));
										}
									});
								}
							});
							jQuery.each(jQuery.isArray(zRows) ? zRows : [zRows], function(idx, zRow) {
								var data = [];
								jQuery.each(headers, function(attrName, ignore) {
									data.push(zRow['@attributes'][attrName] || '');
								});
								if (data.length > 0) {
									self.tabularData.rows.push(data);
								}
							});
						}
					}
				}
				else if (self.error && result.xml) {
					// With ASMX, error details are buried in returned XML, so dig into
					// object we created from XML above to get those details.
					var faultString = getObjectValue(obj, Constants.PathToFaultString);
					var faultDetail = getObjectValue(obj, Constants.PathToFaultDetail);
					if (jQuery.type(faultString) === 'string')
						self.error += ' ' + ensureCharAtEnd(faultString, '.');
					if (jQuery.type(faultDetail) === 'string')
						self.error += ' ' + ensureCharAtEnd(faultDetail, '.');
				}
			}
			else if (self.api === ApiNames.JsomApi) {
				if (!(self.error)) {
					// Successful JSOM result. Convert into tabular data for display.
					var pos = result.listItems.get_listItemCollectionPosition();
					if (pos) {
						self.nextPage = pos.get_pagingInfo();
						self.prevPage = null;
					}
					var looper = result.listItems.getEnumerator();
					var idx = 0;
					while (looper.moveNext()) {
						var item = looper.get_current();
						var fieldVals = item.get_fieldValues();
						var data = [];
						jQuery.each(fieldVals, function(key, val) {
							if (idx < 1) {
								self.tabularData.headers.push(key);
							}
							if (val) {
								if (jQuery.type(val) === 'string')
									// String values are easy; just push them as-is
									data.push(val);
								else if (jQuery.type(val) === 'date')
									// For values of type 'date', convert them to UTC if the "Dates in UTC" flag was specified.
									// (SharePoint does this for dates it sends as strings but not for actual 'date' objects.)
									data.push(parent.datesInUtc() ? val.toUTCString() : val.toString());
								else if (val instanceof SP.FieldUserValue || val instanceof SP.FieldLookupValue)
									// Classes for lookup field values don't override toString(), so we do our own conversion
									// here to mimic what the ASMX API sends for these.
									data.push(val.get_lookupId() + ';#' + val.get_lookupValue());
								else
									// For anything else, just call toString(); most JSOM objects override toString() to output something meaningful
									data.push(val.toString());
							}
							else {
								data.push('');
							}
						});
						if (data.length > 0) {
							self.tabularData.rows.push(data);
						}
						idx++;
					}
					self.csvData(csv);
				}
			}
		}
		
		function getObjectValue(obj, path) {
			var val = (obj || {});
			var segments = (path || '').split('>');
			for (var i = 0; i < segments.length; i++) {
				var segment = segments[i].trim();
				if (val[segment])
					val = val[segment];
			}
			return val;
		}
		
		function ensureCharAtEnd(input, c) {
			if (input && input[input.length - 1] !== c)
				return input + c;
			else
				return input; // note: null/empty/undefined input returned as-is
		}
		
		function executeQueryWithAsmx(page) {
			self.executingQuery(true);

			var soapBody = '<listName>' + self.selectedList() + '</listName><viewName></viewName><query>' + queryXml() + '</query><viewFields>' + viewFieldXml() + '</viewFields><rowLimit>' + self.rowLimit() + '</rowLimit><queryOptions>' + getQueryOptionsXml(page) + '</queryOptions>';

			jQuery.ajax({
				url: ctx.get_url() + Constants.ListServiceUrl,
				type: 'POST',
				dataType: 'xml',
				data: Constants.SoapEnvStart + soapBody + Constants.SoapEnvEnd,
				contentType: 'text/xml; charset="utf-8"'
			})
			.done(function(result, status, jqXhr) {
				try {
					var pageNum = (page && self.queryResult()) ? self.queryResult().currentPage + 1 : 1;
					var result = { httpStatus: jqXhr.status, httpStatusText: jqXhr.statusText, rawData: jqXhr.responseText, xml: jqXhr.responseXML};
					self.queryResult(new QueryResult(self, ApiNames.AsmxApi, result, null, pageNum));
				}
				catch (ex) {
					self.scriptError(ex);
					throw ex;
				}
				finally {
					self.executingQuery(false);
				}
			})
			.fail(function(jqXhr, status, error) {
				try {
					var result = { httpStatus: jqXhr.status, httpStatusText: jqXhr.statusText, rawData: null, xml: jqXhr.responseXML };
					self.queryResult(new QueryResult(self, ApiNames.AsmxApi, result, error));
				}
				catch (ex) {
					self.scriptError(ex);
					throw ex;
				}
				finally {
					self.executingQuery(false);
				}
			})
			.always(function() {
				self.executingQuery(false);
				self.visibleSectionId('results-section');
			});
		}
		
		function getIncludeClauseForJsom() {
			var include = null;
			var xml = viewFieldXml();
			if (xml) {
				var result;
				var fields = '';
				while (result = Constants.FieldNameRegex.exec(xml)) {
					if (result && result.length > 1) {
						for (var i = 1; i < result.length; i++) {
							if (result[i]) {
								fields += result[i] + ',';
							}
						}
					}
				}
				if (fields)
					include = 'Include(' + fields.substring(0, fields.length - 1) + ')';
			}
			return include;
		}
		
		function executeQueryWithJsom(page) {
			self.executingQuery(true);
			
			var list = ctx.get_web().get_lists().getByTitle(_selectedList());
			var query = new SP.CamlQuery();
			query.set_datesInUtc(self.datesInUtc());
			query.set_folderServerRelativeUrl(self.folderUrl());
			query.set_viewXml(viewXml());
			
			if (page && page === 'next') {
				var pos = new SP.ListItemCollectionPosition();
				pos.set_pagingInfo(self.queryResult().nextPage);
				query.set_listItemCollectionPosition(pos);
			}
			
			var include = getIncludeClauseForJsom();
			var items = list.getItems(query);
			
			(include) ? ctx.load(items, 'ListItemCollectionPosition, ' + include) : ctx.load(items);
			
			ctx.executeQueryAsync(
				function() {
					try {
						var pageNum = (page && self.queryResult()) ? self.queryResult().currentPage + 1 : 1;
						var result = { listItems: items };
						self.queryResult(new QueryResult(self, ApiNames.JsomApi, result, null, pageNum));
					}
					catch (ex) {
						self.scriptError(ex);
						throw ex;
					}
					finally {
						self.executingQuery(false);
						self.visibleSectionId('results-section');
					}
				},
				function(s, args) {
					try {
						var result = { rawData: 'data' };
						var error = args.get_message().replace(Constants.ErrorPrefixRegex, '');
						if (args.get_errorTypeName())
							error = 'An error of type ' + args.get_errorTypeName() + ' has occurred. ' + error;
						if (args.get_errorTraceCorrelationId())
							error += ' Correlation ID = ' + args.get_errorTraceCorrelationId();
						self.queryResult(new QueryResult(self, ApiNames.JsomApi, result, error));
					}
					catch (ex) {
						self.scriptError(ex);
						throw ex;
					}
					finally {
						self.executingQuery(false);
						self.visibleSectionId('results-section');
					}
				}
			);
		}
		
		function mapCollection(obj, callback) {
			var result = [];
			if (obj && obj.getEnumerator && callback) {
				var looper = obj.getEnumerator();
				while (looper.moveNext()) {
					result.push(callback(looper.get_current()));
				}
			}
			return result;
		}

		function fetchLists() {
			self.loadingLists(true);
			var lists = ctx.get_site().openWeb(self.siteUrl()).get_lists();
			ctx.load(lists, 'Include(RootFolder, Title)');
			ctx.executeQueryAsync(
				function() {
					self.queryResult(null);
					self.camlQuery(Constants.DefaultCamlQuery);
					// short timeout to give CAML text time to update (otherwise requires user clicking in text box after lists loaded)
					setTimeout(function() {
						self.selectedList(null);
						self.lists(mapCollection(lists, function(list) {
							try {
								listFolders[list.get_title()] = list.get_rootFolder().get_serverRelativeUrl();
							} catch (ex) { }
							return list.get_title();
						}));
						self.loadingLists(false);
					}, 300);
				},
				function(s, args) {
					self.loadingLists(false);
					alert('Error fetching lists and libraries: ' + args.get_message().replace(Constants.ErrorPrefixRegex, ''));
				}
			);
		}
		
		function removeQuotes(input) {
			return (input || '').replace(/[";]/g, '');
		}
		
		function updateListFields() {
			var listName = _selectedList();
			if (listName) {
				var list = ctx.get_web().get_lists().getByTitle(listName);
				var fields = list.get_fields();
				ctx.load(fields, 'Include(InternalName, Title)');
				ctx.executeQueryAsync(
					function() {
						var result = mapCollection(fields, function(fld) {
							return { name: fld.get_internalName(), title: fld.get_title() };
						});
						result.sort(function(a, b) {
							if (a.title > b.title)
								return 1;
							if (a.title < b.title)
								return -1;
							return 0;
						});
						jQuery('#list').data('fields', result);
					},
					function(s, args) {
						console.log('Error fetching list fields: ' + args.get_message().replace(Constants.ErrorPrefixRegex, ''));					
					}
				);
			}
		}

		function xmlToJson(xml) {
			// Note: We use this function for converting an XML doc to JSON rather than jQuery
			// because jQuery always lower-cases attribute names, which we don't want. SharePoint's
			// ASMX API returns field names as attributes in XML, and those field names are
			// case-sensitive.
			
			var obj = {};
		
			if (xml.nodeType == 1) { // element
				// do attributes
				if (xml.attributes.length > 0) {
				obj["@attributes"] = {};
					for (var j = 0; j < xml.attributes.length; j++) {
						var attribute = xml.attributes.item(j);
						obj["@attributes"][attribute.nodeName] = attribute.nodeValue;
					}
				}
			} else if (xml.nodeType == 3) { // text
				obj = xml.nodeValue;
			}
		
			// do children
			if (xml.hasChildNodes()) {
				for(var i = 0; i < xml.childNodes.length; i++) {
					var item = xml.childNodes.item(i);
					var nodeName = item.nodeName;
					if (typeof(obj[nodeName]) == "undefined") {
						obj[nodeName] = xmlToJson(item);
					} else {
						if (typeof(obj[nodeName].push) == "undefined") {
							var old = obj[nodeName];
							obj[nodeName] = [];
							obj[nodeName].push(old);
						}
						obj[nodeName].push(xmlToJson(item));
					}
				}
			}
			return obj;
		};
		
		// View-model initialization
		
		fetchLists();
	}
	
	/**
	 * Custom Knockout JS binding for ACE Editor (to bind text to view-model property).
	 **/
	ko.bindingHandlers.aceText = {
		init: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
			var editor = ace.edit(element.id);
			editor.on('change', function(e) {
				valueAccessor()(editor.getValue());
			});
		},
		update: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
			var editor = ace.edit(element.id);
			var newValue = ko.unwrap(valueAccessor()) || '';
			if (editor.getValue() != newValue) {
				editor.setValue(newValue, -1);
			}
		}
	};

	/**
	 * QuickCAML initialization logic.
	 **/
	(function() {
		// Replacement auto-indent behavior for XML mode of ACE Editor
		// (the default one doesn't handle self-closing tags properly)
		function autoIndent(state, action, editor, session, text) {
	        if (text == "\n") {
	        	var ti = ace.require('ace/token_iterator');
	            var cursor = editor.getCursorPosition();
	            var line = session.getLine(cursor.row);
	            var iterator = new ti.TokenIterator(session, cursor.row, cursor.column);
	            var token = iterator.getCurrentToken();
	            
	            // BTM: Added this line to prevent indenting after self-closing tags
                var selfClosing = (token && token.type.indexOf("tag-close") !== -1 && token.value == "/>");
	
	            if (token && token.type.indexOf("tag-close") !== -1) {
	                //get tag name
	                while (token && token.type.indexOf("tag-name") === -1) {
	                    token = iterator.stepBackward();
	                }
	
	                if (!token) {
	                    return;
	                }
	
	                var tag = token.value;
	                var row = iterator.getCurrentTokenRow();
	
	                token = iterator.stepBackward();
	                
   	                //don't indent after closing tag (BTM: Added the 'selfClosing' check at the end)
	                if (!token || token.type.indexOf("end-tag") !== -1 || selfClosing) {
	                    return;
	                }

                    var nextToken = session.getTokenAt(cursor.row, cursor.column+1);
                    var line = session.getLine(row);
                    var nextIndent = line.match(/^\s*/)[0];
                    var indent = nextIndent + session.getTabString();

                    if (nextToken && nextToken.value === "</") {
                        return {
                            text: "\n" + indent + "\n" + nextIndent,
                            selection: [1, indent.length, 1, indent.length]
                        };
                    } else {
                        return {
                            text: "\n" + indent
                        };
                    }
	            }
	        }
		}
	
		function initCamlEditor() {
			var camlCompleter = new CamlCompleter();
			var editor = ace.edit('camlEditor');
			editor.setOptions({
				mode: 'ace/mode/xml',
				showPrintMargin: false,
				enableBasicAutocompletion: [ camlCompleter ],
				enableLiveAutocompletion: [ camlCompleter ]
			});
			editor.commands.removeCommand('showSettingsMenu');
			editor.on('change', function(e) {
				if (e.data.action === 'insertText' && e.data.text) {
					if (e.data.text.lastIndexOf('=""') > -1) {
						// Not super thrilled with this approach but there's no "snippet inserted" event on the ACE editor that
						// we can hook into; this is intended to catch an attribute snippet insertion so we can show intellisense
						// for the values of the attribute like Visual Studio and SharePoint Designer do; tried using other events
						// but certain things were always off due to timing issues (hence the setTimeout call below).
						setTimeout(function() {
							editor.execCommand('startAutocomplete');
						}, 300);
					}
				}
			});
			editor.on('changeMode', function(e) {
				var mode = editor.getSession().getMode();
				if (jQuery.type(mode) === 'object' && mode.$id === 'ace/mode/xml' && mode.$behaviour) {
					// Replace default auto-indent XML behavior of ACE editor with our own
					mode.$behaviour.remove('autoindent');
					mode.$behaviour.add('autoindent', 'insertion', autoIndent);
				}
			});
		}
		
		function initjQueryUI() {
			jQuery('#calendarDate').datepicker();
			jQuery('#tabs').tabs();
		}
		
		jQuery(document).ready(function() {
			initCamlEditor();
			initjQueryUI();
			var ctx = SP.ClientContext.get_current();
			ko.applyBindings(new QuickCAMLViewModel(ctx));		
		});
	})();
	
	// QuickCAML v0.5 (BETA)

</script>

</asp:Content>
