--[[ This is how you derandomize this RNG
local old = getmetatable;
local w = 0;
getmetatable = function(tbl)
    w = w + 1;
    if w >= 490 and type(tbl) == 'table' then
        return {
            __tostring = function()
                return 'table: 0x558eb72e8c70';
            end;
        }
    end;
    return old(tbl);
end;
]]

custom_functions = {
    tonumber = function(s)  -- // Convert a string of digits to a number
        local result, multiplier = 0, 1;
        for i = #s, 1, -1 do  -- // Iterate over each character, converting it to a digit and adding to result
            result = result + (string.byte(s, i) - 48) * multiplier;
            multiplier = multiplier * 10; -- // Increase multiplier for next digit
        end;
        return result;
    end,
    
    tostring = function(value)  -- // Convert a value of any type to a string
        local handlers = {
            -- // Define conversion functions for different types
            string = function() return value; end,
            number = function() return string.format("%g", value); end,
            boolean = function() return value and "true" or "false"; end,

            table = function()
                local mt = getmetatable(value);  -- // Check for a metatable with a custom tostring method
                return (mt and mt.__tostring and mt.__tostring(value)) or string.format("table: %s", tostring(value));
            end,

            userdata = function()
                local mt = getmetatable(value);  -- // Check for a metatable with a custom tostring method
                return (mt and mt.__tostring and mt.__tostring(value)) or string.format("userdata: %s", tostring(value));
            end;
        };

        return (handlers[type(value)] or function() return string.format("<unknown type: %s>", type(value)); end)();
    end,
    
    sub = function(s, i, j)  -- // Extract a substring from a string
        local result = "";
        for idx = i, j do  -- // Concatenate characters between i and j
            result = result .. string.char(string.byte(s, idx));
        end;
        return result;
    end,
    
    gsub = function(s, pattern, replacement)  -- // Replace occurrences of a pattern in a string
        -- // Loop through the string, replacing each occurrence of the pattern
        local start_index, end_index = string.find(s, pattern);
        while start_index do
            s = custom_functions.sub(s, 1, start_index - 1) .. replacement .. custom_functions.sub(s, end_index + 1, #s);
            start_index, end_index = string.find(s, pattern, start_index + #replacement);
        end;
        return s;
    end,
};

rng = {
   local seed, combo, prev, last_two_strings, generated_strings = 0, 0, 0, {"", ""}, {};
    generate_randomstring = function(l)  -- // Generate a random string of a given length
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        local str = "";
        while true do
            str = "";
            for i = 1, l do
                local new_thing =  
                    custom_functions.tonumber(
                        custom_functions.gsub(custom_functions.tostring({i * i, l * l, i * l}), "%D", "") -- // Generate a numeric value based on index and length
                    );
                local index = (new_thing % #chars) + 1; -- // Map the number to a character index
                str = str .. custom_functions.sub(chars, index, index); -- // Append character to string
            end;

            -- // Check if the generated string is unique
            if str ~= rng.last_two_strings[1] and str ~= rng.last_two_strings[2] and not rng.generated_strings[str] then
                rng.last_two_strings[1], rng.last_two_strings[2] = str, rng.last_two_strings[1];
                rng.generated_strings[str] = true;
                break;
            end;
        end;
        return str;
    end,

    check_seed = function()  
        return rng.seed; -- // Return the current seed value
    end;
};

-- // Generate 50 random strings and update the seed value
(function()
  local self, check_seed = rng, rng.seed;
    for i = 1, 50 do
        local n, hash = self.generate_randomstring(10), 0;
        for j = 1, #n do 
            hash = (hash * 31 + custom_functions.tonumber(custom_functions.tostring(n:byte(j)))) % 2 ^ 31; -- // Calculate a hash for the string
        end

        -- // Update the rng state based on the generated hash
        self.combo, self.prev, self.seed = (hash == self.prev) and self.combo + 1 or 0, hash, hash;
    end

    -- // Check for excessive repetition or unchanged seed value
    if self.combo > 45 or self.seed == check_seed then
        return;
    end;
end)();
