
# グローバルなアプリケーションの状態はこのモデルで管理。

class App extends Backbone.Model
	
	initialize: ->
	
	### とりあえずロード進捗表示は後で実装
	# セオリーに反するけれどとりあえずここにおいておく
	loading = new class
		constructor: ->
		# ローディングダイアログを表示
		show: ->
		# ローディングダイアログを隠す
		# timeout: タイムアウト時間[ms]
		hide: (timeout=1000) ->
			
	defaults:
		loadingCount: 0 # ローディング中のモデル数
		
	beginLoading: ->
		c = @get "loadingCount"
		loading.show() if c is 0
		@set "loadingCount", c + 1
		
	endLoading: (timeout) ->
		c = @get "loadingCount"
		loading.hide() if c is 1
		@set "loadingCount", c - 1
	###




