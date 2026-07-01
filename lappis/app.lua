local lapis = require "lapis"
-- local Model = require("lapis.db.model").Model
-- local capture_errors = require("lapis.application").capture_errors
local csrf = require "lapis.csrf"

-- local Users = Model:extend("users")

local app = lapis.Application()

app:before_filter(function(self)
  self.csrf_token = csrf.generate_token(self)
end)

-- Define a basic pattern that matches /
app:match("/", function(self)
  local profile_url = self:url_for("profile", {name = "leafo"})
  -- Use HTML builder syntax helper to quickly and safely write markup
  return self:html(function()
    h2("Welcome!")
    text("Go to my ")
    a({href = profile_url}, "profile")
  end)
end)

-- Define a named route pattern with a variable called name
app:match("profile", "/:name", function(self)
  return self:html(function()
    div({class = "profile"},
      "Welcome to the profile of " .. self.params.name)
  end)
end)

-- app:get("list_users", "/users", function(self)
--   self.users = Users:select() -- `select` all users
--   return { render = true }
-- end)

-- app:get("user", "/profile/:id", function(self)
--   local user = Users:find({ id = self.params.id })
--   if not user then
--     return { status = 404 }
--   end

--   return { render = true }
-- end)

-- app:post("new_user", "/user/new", capture_errors(function(self)
--   csrf.assert_token(self)
--   Users:create({
--     name = assert_error(self.params.username, "Missing username")
--   })

--   return { redirect_to = self:url_for("list_users") }
-- end))

-- app:get("new_user", "/user/new", function(self)
--   return { render = true }
-- end)

return app