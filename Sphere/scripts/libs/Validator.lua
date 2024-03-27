--
-- validation.lua
--
-- Copyright (c) 2016 erento
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--

local validation = {}

---@param validator? function
function validation.is_string(validator)
  return function(value, key, data)

    if type(value) ~= 'string' then
      return false, 'is not a text(THIS IS NOT A SPHERE BUG)'
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
      return false, 'is not a integer(THIS IS NOT A SPHERE BUG)'
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
      return false, 'is not a number(THIS IS NOT A SPHERE BUG)'
    elseif validator then
      return validator(value, key, data)
    else
      return true
    end
  end
end

---@param validator? function
function validation.is_positive(validator)
  return function(value, key, data)

    if value < 0 then
      return false, 'is negative(THIS IS NOT A SPHERE BUG)'
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
      return false, 'is not true or false(THIS IS NOT A SPHERE BUG)'
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
      table.insert(err_array, 'is not an array(THIS IS NOT A SPHERE BUG)')
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
      table.insert(err, "is not a table.(THIS IS NOT A SPHERE BUG)")
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
      return false, string.format("%s is not valid(THIS IS NOT A SPHERE BUG)", value)
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
      return false, "is required and was not found(THIS IS NOT A SPHERE BUG)"
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
      return false, "exceeded the maximum number of elements(THIS IS NOT A SPHERE BUG)"
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
      return false, string.format("is not within the specified range [%d, %d](THIS IS NOT A SPHERE BUG)", lower, upper)
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
      errs[key] = 'is not allowed.(THIS IS NOT A SPHERE BUG)'
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