local global_inversions = vim.tbl_add_reverse_lookup({
  ['true'] = 'false',
  ['yes'] = 'no',
  ['on'] = 'off',
  ['left'] = 'right',
  ['up'] = 'down',
})

local toggle_mapping = '<leader>i'

local filetype_inversions = {}

local setup = function(u_tbl)
  global_inversions = vim.tbl_extend(
    'force',
    global_inversions,
    vim.tbl_add_reverse_lookup(u_tbl.global_inversions or {})
  )

  for ft, inversions in pairs(u_tbl.filetype_inversions or {}) do
    filetype_inversions[ft] = vim.tbl_extend(
      'force',
      filetype_inversions[ft] or {},
      vim.tbl_add_reverse_lookup(inversions)
    )
  end

  toggle_mapping = u_tbl.toggle_mapping or toggle_mapping
  local opts = { noremap = true, silent = true }
  vim.keymap.set({ 'n', 'v' }, toggle_mapping, toggle, opts)
end

local c = {
  ['n'] = 'norm! ciw',
  ['v'] = 'norm! c',
}

function toggle()
  local i = vim.tbl_get(global_inversions, vim.fn.expand('<cword>'))
  if filetype_inversions[vim.bo.filetype] then
    fi = vim.tbl_get(
      filetype_inversions[vim.bo.filetype],
      vim.fn.expand('<cword>')
    )
    i = fi or i
  end
  xpcall(function()
    vim.cmd(vim.tbl_get(c, vim.api.nvim_get_mode().mode) .. i)
  end, function()
    print('toggler: unsupported value.')
  end)
end

return { setup = setup }
