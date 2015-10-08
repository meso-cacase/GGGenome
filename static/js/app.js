Ext.define('app', {
	singleton: true,
	config: {
		appName: 'GGGenome',
		regexpName2Id : /[^A-Za-z0-9]/g,
	},
	constructor: function(config) {
		this.initConfig(config);
//		this.initApp();
		return this;
	},
	warn : function(msg){
		if(window.console){
			if(window.console.warn) window.console.warn(msg);
		}
	},
	name2id : function(name){
		var self = this;
		try{if(!Ext.isString(name)) name = name.toString();}catch(e){self.warn(e);name='';}
		return name.replace(self.getRegexpName2Id(),'-').toLowerCase();
	},
	makeId : function(){
		var self = this;
		var arr = [self.name2id(self.getAppName())];
		var i;
		for (i = 0; i < arguments.length; i++) {
			arr.push(self.name2id(arguments[i]));
		}
		return arr.join('-');
	},

	initStore : function(){
		var self = this;
		var datas = Ext.query('form[name='+self.getAppName().toLowerCase()+'] select[name=db]>option').map(function(dom){
			var el = Ext.get(dom);
			var synonym = (el.getAttribute('synonym') || '');
			return {
				db : el.getValue(),
				fullname : el.getHTML(),
				synonym : Ext.isEmpty(synonym) ? [] : synonym.toLowerCase().split(';').map(function(val){ if(Ext.isString(val)){ return val.trim() }else{ return '' }}),
				disabled: el.getAttribute('disabled') ? true : false
			};
		});
//		console.log(datas);
		self._dblistStore = Ext.create('app.store.dblist', {
			storeId: self.makeId('store','dblist'),
			data : datas
		});


		var genes = Ext.query('div.gene').map(function(dom){
			var el = Ext.get(dom);
			var rtn = {};
			Ext.each(['name','length','position','position_end','snippet','snippet_pos','snippet_5prime','snippet_3prime','sbjct'],function(name){
				var node = el.query('input[type=hidden][name=gene.'+name+']')[0];
				if(Ext.isEmpty(node)) return true;
				rtn[name] = Ext.get(node).getValue();
			});
			return rtn;
		});
//		console.log(genes);

		var total_node = Ext.query('input[type=hidden][name=total]')[0];
		var offset_node = Ext.query('input[type=hidden][name=offset]')[0];
		var pageSize_node = Ext.query('input[type=hidden][name=limit]')[0];
		var pageSize = 25;
		var currentPage = 1;
		if(pageSize_node) pageSize = parseInt(Ext.get(pageSize_node).getValue());
		if(offset_node) currentPage = parseInt(Ext.get(offset_node).getValue()) / pageSize + 1;

		self._resultsStore = Ext.create('app.store.results', {
			storeId: self.makeId('store','results'),
			pageSize: pageSize,
			currentPage: currentPage,
			data : {
				total: total_node ? Ext.get(total_node).getValue() : 0,
				datas: genes
			}
		});
	},

	initUI : function(){
		var self = this;
		var db_element;
		try{db_element = Ext.get(Ext.query('form[name='+self.getAppName().toLowerCase()+'] select[name=db]')[0]);}catch(e){}
		if(Ext.isEmpty(db_element)) return;
		db_element.hide();
		var dblist_render_html = Ext.DomHelper.createDom({tag:'div',cls:'dblist-render'});
		var dblist_render = Ext.get(dblist_render_html)

		self._dblistComboBox = Ext.create('app.field.dblist', {
			id: self.makeId('ComboBox','dblist'),
			hiddenLabel: true,
			store: self.makeId('store','dblist'),
			value: db_element.getValue(),
			width: db_element.getWidth(),
			listConfig: {
				cls: 'dblist-boundlist'
			},
			renderTo: dblist_render,
			queryFilter: new Ext.util.Filter({
				filterFn: function(item) {
					var value = (this.value||'').toLowerCase();
					var idx = item.get('fullname').toLowerCase().indexOf(value);
					if(idx<0){
						Ext.each(item.get('synonym'),function(synonym){
							idx = synonym.indexOf(value);
							if(idx>=0) return false;
						});
					}
					return idx>=0;
				}
			})
		});
		if(self._dblistComboBox.queryFilter) self._dblistComboBox.store.addFilter(self._dblistComboBox.queryFilter, false);

		dblist_render.replace(db_element);


		var data_exports = Ext.query('h4#data_export');
		if(!Ext.isEmpty(data_exports)){
			var data_export_element = Ext.get(data_exports[data_exports.length-1]);
			var pagingToolbar_render_html = Ext.DomHelper.createDom({tag:'div',cls:'pagingToolbar-render'});
			var pagingToolbar_render = Ext.get(pagingToolbar_render_html).insertBefore(data_export_element);

			self._pagingToolbar = Ext.create('Ext.toolbar.Paging', {
				border: false,
				store: self.makeId('store','results'),
				displayInfo: true,
				inputItemWidth: 50,
				renderTo: pagingToolbar_render,
				listeners : {
					beforechange: function(pagingToolbar, page, eOpts){
						var search = Ext.Object.fromQueryString(window.location.search.substr(1));
						search.offset = (page-1) * pagingToolbar.getStore().pageSize;
						if(search.offset==0) delete search.offset;
						var search_string = Ext.Object.toQueryString(search);
						if(Ext.isEmpty(search_string)){
							window.location.href = window.location.protocol + '//' + window.location.host + window.location.pathname + (Ext.isEmpty(window.location.hash.substr(1)) ? '' : window.location.hash);
						}else{
							window.location.search = search_string;
						}
						return false;
					}
				}
			});
		}
	},

	initApp: function() {
		var self = this;
		self.initStore();
		self.initUI();
	}
});
//Model
Ext.define('app.model.dblist',{
	extend: 'Ext.data.Model',
	fields: [
		{name: 'db',       type: 'string'},
		{name: 'source',   type: 'string'},
		{name: 'fullname', type: 'string'},
		{name: 'synonym',  type: 'auto'},
		{name: 'disabled', type: 'boolean', defaultValue: false},
		{name: 'hidden',   type: 'boolean', defaultValue: false}
	]
});
Ext.define('app.model.results',{
	extend: 'Ext.data.Model',
	fields: [
		{name: 'name', type: 'string'},
		{name: 'length', type: 'int'},
		{name: 'position', type: 'int'},
		{name: 'position_end', type: 'int'},
		{name: 'snippet', type: 'string'},
		{name: 'snippet_pos', type: 'int'},
		{name: 'snippet_5prime', type: 'string'},
		{name: 'snippet_3prime', type: 'string'},
		{name: 'sbjct', type: 'string'}
	]
});
//Store
Ext.define('app.store.dblist',{
	extend: 'Ext.data.Store',
	model: 'app.model.dblist',
	proxy: {
		type: 'memory',
		reader: {
			type: 'json'
		}
	}
});
Ext.define('app.store.results',{
	extend: 'Ext.data.Store',
	model: 'app.model.results',
	proxy: {
		type: 'memory',
		reader: {
			type: 'json',
			root: 'datas'
		}
	}
});
//form.field
Ext.define('app.field.dblist', {
	extend: 'Ext.form.field.ComboBox',
	alias: 'widget.appdblist',
//	name: 'db',
	hiddenName: 'db',
	allowBlank: false,
	anyMatch: true,
	editable: true,
	hideLabel: true,
	selectOnFocus: true,
	queryMode: 'local',
	displayField: 'fullname',
	valueField: 'db',
	validator: function(v){
		return this.getStore().getCount() ? true : false;
	},
	onBeforeSelect: function(list, record) {
		var me = this;
		if(record.data.disabled) return false;
		return me.callParent(arguments);
	}
});

Ext.onReady(function(){
	app.initApp();
	Ext.getBody().setStyle({'visibility':'visible'});
});
