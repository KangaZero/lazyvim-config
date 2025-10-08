-- lua/which_github.lua
local M = {}
local raw_json = ""

-- 🧩 Get text under cursor or selected visually
function M.get_repo()
  local mode = vim.fn.mode()
  local repo = ""

  if mode == "v" or mode == "V" then
    -- Visual selection
    vim.cmd('normal! "vy') -- yank selection into register v
    repo = vim.fn.getreg("v")
  else
    repo = vim.fn.expand("<cWORD>")
  end

  repo = repo:gsub("%s+", "") -- trim spaces
  return repo
end

function remove_quotes(str)
  return str:gsub("^['\"]", ""):gsub("['\"]$", "")
end

M.get_repo_info = function()
  local repo = M.get_repo()
  if not repo or repo == "" then
    print("No repo name provided")
    return
  end

  repo = remove_quotes(repo)
  local url = "https://api.github.com/repos/" .. repo
  -- local token = os.getenv("GITHUB_TOKEN") or ""
  -- local auth_header = token ~= "" and ("-H 'Authorization: token " .. token .. "'") or ""

  local cmd = string.format("curl -X GET %s", url)
  local handle = io.popen(cmd)
  if not handle then
    print("Error running curl")
    return
  end

  local result = handle:read("*a")
  handle:close()

  if not result or result == "" then
    print("Empty response from GitHub")
    return
  end

  -- Try to decode JSON
  local ok, json = pcall(vim.json.decode, result)
  if not ok then
    print("Failed to parse JSON:\n" .. result)
    return
  end
  -- Display key info
  if json.message then
    print("GitHub API error: " .. json.message)
  else
    raw_json = json
    print("📦 Repo: " .. (json.full_name or "unknown"))
    print("⭐ Stars: " .. (json.stargazers_count or "N/A"))
    print("🍴 Forks: " .. (json.forks_count or "N/A"))
    print("Allow Forking: " .. (json.allow_forking and "👌" or "🚫"))
    print("📝 Description: " .. (json.description or ""))
  end
end

function M.yank_raw_json()
  if not raw_json or raw_json == "" then
    print("No raw JSON available or failed to fetch repo info")
    return
  end
  -- If it's a Lua table, convert it to JSON
  local json_str
  if type(raw_json) == "table" then
    local ok, encoded = pcall(vim.json.encode, raw_json)
    if not ok then
      print("Failed to encode JSON")
      return
    end
    json_str = encoded
  else
    json_str = raw_json
  end

  -- see https://stackoverflow.com/questions/3961859/how-to-copy-to-clipboard-in-vim
  vim.fn.setreg("*", json_str)
  print("📋 Raw JSON copied to clipboard!")
end

return M
