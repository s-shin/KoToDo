
class App extends Backbone.Model
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




