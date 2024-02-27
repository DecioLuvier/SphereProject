--Starting point for creating this
--https://github.com/erento/lua-schema-validation

local validation = {}

---@param validator? function
function validation.is_string(validator)
  return function(value, key, data)

    if type(value) ~= 'string' then
      return false, 'is not a text'
    elseif validator then
      return validator(value, key, data)
    else
      return true
    end
  end
end

---@param validator? function
function validation.is_integer(validator)
  return function(value, key, data)

    if type(value) ~= 'number' or value%1 ~= 0 then
      return false, 'is not a integer'
    elseif validator then
      return validator(value, key, data)
    else
      return true
    end
  end
end

---@param validator? function
function validation.is_number(validator)
  return function(value, key, data)

    if type(value) ~= 'number' then
      return false, 'is not a number'
    elseif validator then
      return validator(value, key, data)
    else
      return true
    end
  end
end

---@param validator? function
function validation.is_boolean(validator)
  return function(value, key, data)
    
    if type(value) ~= 'boolean' then
      return false, 'is not true or false'
    elseif validator then
      return validator(value, key, data)
    else
      return true
    end
  end
end

---@param validator? function
function validation.is_array(validator)
  return function(value, key, data)
    local result, err = nil
    local err_array = {}


    if type(value) == 'table' then
      for index in pairs(value) do

        result, err = validator(value[index], index, data)
        
        if not result then
          err_array[index] = err
        end
      end
    else
      insert(err_array, 'is not an array')
    end

    if next(err_array) == nil then
      return true
    else
      return false, err_array
    end
  end
end

---@param validator? function
function validation.is_table(schema)
  return function(value)
    local result, err = nil

    if type(value) ~= 'table' then
      _, err = validation.is_table_implementation({}, schema)

      if not err then err = {} end
      result = false
      insert(err, "is not a table.")
    else
      result, err = validation.is_table_implementation(value, schema)
    end
    return result, err
  end
end

---@param validator? function
function validation.is_KeyOfList(list, validator)
  return function(value, key, data)

    if not list[value] then
      return false, "is not valid"
    elseif validator then
      return validator(value, key, data)
    else
      return true
    end
  end
end

---@param validator? function
function validation.optional(validator)
  return function(value, key, data)
    if value == nil then
      return true
    else
      return validator(value, key, data)
    end
  end
end

---@param validator? function
function validation.required(validator)
  return function(value, key, data)
    if value == nil then 
      return false, "is required and was not found"
    else
      return validator(value, key, data)
    end
  end
end

---@param size number
---@param validator? function
function validation.array_max(size,validator)
  return function(value, key, data)

    if key > size then 
      return false, "exceeded the maximum number of elements"
    elseif validator then
      return validator(value, key, data)
    else
      return true
    end
  end
end

---@param lower number
---@param upper number
---@param validator? function
function validation.in_range(lower, upper,validator)
  return function(value, key, data)

    if value < lower or value > upper then
      return false, string.format("is not within the specified range [%d, %d]", lower, upper)
    elseif validator then
      return validator(value, key, data)
    else
      return true
    end
  end
end

function validation.is_table_implementation(data, schema)
  local errs = {}
  for key in pairs(data) do

    if schema[key] == nil then
      errs[key] = 'is not allowed.'
    end
  end
  for key in pairs(schema) do
    local result, err = schema[key](data[key], key, data)

    if not result then
      errs[key] = err
    end
  end
  for _ in pairs(errs) do
    return false, errs
  end
  return true
end

return validation