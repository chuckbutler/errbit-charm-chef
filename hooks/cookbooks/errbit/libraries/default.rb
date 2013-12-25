$: << File.expand_path('..', __FILE__)

require 'assets/asset_helper'

class Chef::Recipe
	include AssetHelper
end