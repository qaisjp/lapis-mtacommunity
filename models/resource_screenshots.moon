import Model from require "lapis.db.model"
import Users from require "models"
class ResourceScreenshots extends Model
    -- Has created_at and modified_at
    @timestamp: true
    
    url_params: (reg, ...) => "resources.view_screenshot", { resource_slug: @resource, screenie_id: @id }, ...

    -- get the direct url of this resource (not the page with the title and description, but the raw image data)
    get_direct_url: (context) =>
    	res = @resource
    	if type(res) == "number"
    		res = Users\find res
		context\url_for "resources.view_screenshot_image", resource_slug: res, screenie_id: @id
