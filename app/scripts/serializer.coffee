# JSONSerializer =

# 	serialize: (obj) ->

# 		switch typeof obj
# 			when "object" then json = @serializeObject(obj)
# 			else console.log(typeof obj)

# 	serializeObject: (obj) ->

# 		if typeof obj.toJSON == 'function'
# 			json = obj.toJSON()
# 			json._type = obj.constructor.name

# 		else
# 			json = obj

# 		JSON.stringify json



# 	deserialize: (json) ->
# 		json = JSON.parse json

# 		if not json._type?
# 			return json

# 		switch json._type
# 			when "object" then obj = json
# 			else obj = @deserializeObject(json)

# 		obj

# 	deserializeObject: (json) ->
# 		objClass = eval(json.constructor.name);

# 		console.log objClass

# 		if typeof objClass.fromJSON == 'function'
# 			obj = obj.fromJSON(json)

# 		else
# 			obj = json

# 		obj


# this.JSONSerializer = JSONSerializer