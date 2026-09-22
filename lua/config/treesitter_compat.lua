local M = {}

function M.setup()
  -- Neovim 0.12 Compatibility Fix for Tree-sitter
  -- In Neovim 0.12, match[id] passed to directives and predicates is a TSNode[] list
  -- instead of a single TSNode, and the older `all = false` option was dropped.

  -- 1. Guard get_range and get_node_text against table of nodes
  if not M._patched_get_range then
    local orig_get_range = vim.treesitter.get_range
    vim.treesitter.get_range = function(node, source, metadata)
      if type(node) == "table" and node[1] then
        node = node[1]
      end
      return orig_get_range(node, source, metadata)
    end
    M._patched_get_range = true
  end

  if not M._patched_get_node_text then
    local orig_get_node_text = vim.treesitter.get_node_text
    vim.treesitter.get_node_text = function(node, source, opts)
      if type(node) == "table" and node[1] then
        node = node[1]
      end
      return orig_get_node_text(node, source, opts)
    end
    M._patched_get_node_text = true
  end

  -- 2. Hook query.add_directive and query.add_predicate to honor `all = false`
  local ok_query, query = pcall(require, "vim.treesitter.query")
  if not ok_query then
    return
  end

  local function wrap_match_for_all_false(match)
    return setmetatable({}, {
      __index = function(_, k)
        local val = match[k]
        if type(val) == "table" and val[1] then
          return val[1]
        end
        return val
      end,
      __pairs = function()
        return pairs(match)
      end,
      __ipairs = function()
        return ipairs(match)
      end,
    })
  end

  if not M._patched_add_directive then
    local orig_add_directive = query.add_directive
    query.add_directive = function(name, handler, opts)
      if type(opts) == "table" and opts.all == false then
        local orig = handler
        handler = function(match, pattern, source, pred, metadata)
          return orig(wrap_match_for_all_false(match), pattern, source, pred, metadata)
        end
      end
      return orig_add_directive(name, handler, opts)
    end
    M._patched_add_directive = true
  end

  if not M._patched_add_predicate then
    local orig_add_predicate = query.add_predicate
    query.add_predicate = function(name, handler, opts)
      if type(opts) == "table" and opts.all == false then
        local orig = handler
        handler = function(match, pattern, source, pred)
          return orig(wrap_match_for_all_false(match), pattern, source, pred)
        end
      end
      return orig_add_predicate(name, handler, opts)
    end
    M._patched_add_predicate = true
  end

  -- 3. Explicitly re-register nvim-treesitter predicates and directives with unwrap logic
  local html_script_type_languages = {
    ["importmap"] = "json",
    ["module"] = "javascript",
    ["application/ecmascript"] = "javascript",
    ["text/ecmascript"] = "javascript",
  }

  local non_filetype_match_injection_language_aliases = {
    ex = "elixir",
    pl = "perl",
    sh = "bash",
    uxn = "uxntal",
    ts = "typescript",
  }

  local function get_parser_from_markdown_info_string(injection_alias)
    local match = vim.filetype.match({ filename = "a." .. injection_alias })
    return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
  end

  local function get_node(match, id)
    local node = match[id]
    if not node then
      return nil
    end
    if type(node) == "table" then
      return node[1]
    end
    return node
  end

  query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local node = get_node(match, pred[2])
    if not node then
      return
    end
    local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
    metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
  end, { force = true })

  query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
    local node = get_node(match, pred[2])
    if not node then
      return
    end
    local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
    local configured = html_script_type_languages[type_attr_value]
    if configured then
      metadata["injection.language"] = configured
    else
      local parts = vim.split(type_attr_value, "/", {})
      metadata["injection.language"] = parts[#parts]
    end
  end, { force = true })

  query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
    local id = pred[2]
    local node = get_node(match, id)
    if not node then
      return
    end
    local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
    if not metadata[id] then
      metadata[id] = {}
    end
    metadata[id].text = string.lower(text)
  end, { force = true })

  query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
    local node = get_node(match, pred[2])
    local n = tonumber(pred[3])
    if node and node:parent() and node:parent():named_child_count() > n then
      return node:parent():named_child(n) == node
    end
    return false
  end, { force = true })

  query.add_predicate("is?", function(match, _pattern, bufnr, pred)
    local ok_locals, locals = pcall(require, "nvim-treesitter.locals")
    if not ok_locals then
      return true
    end
    local node = get_node(match, pred[2])
    local types = { unpack(pred, 3) }
    if not node then
      return true
    end
    local _, _, kind = locals.find_definition(node, bufnr)
    return vim.tbl_contains(types, kind)
  end, { force = true })

  query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
    local node = get_node(match, pred[2])
    local types = { unpack(pred, 3) }
    if not node then
      return true
    end
    return vim.tbl_contains(types, node:type())
  end, { force = true })
end

M.setup()

return M

