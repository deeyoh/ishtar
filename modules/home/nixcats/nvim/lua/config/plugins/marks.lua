require("lze").load({
  {
    "marks.nvim",
    for_cat = "tools",
    after= function()
      require("marks").setup({
        default_mappings = false,
        bookmark_0 = {
          sign = "⚑",
        },
        bookmark_1 = {
          sign = "⚑",
        },
        bookmark_2 = {
          sign = "⚑",
        },
        bookmark_3 = {
          sign = "⚑",
        },
        bookmark_4 = {
          sign = "⚑",
        },
        bookmark_5 = {
          sign = "⚑",
        },
        bookmark_6 = {
          sign = "⚑",
        },
        bookmark_7 = {
          sign = "⚑",
        },
        bookmark_8 = {
          sign = "⚑",
        },
        mappings = {
          set_next = "m;",
          next = "nm",
          prev = "bm",
          delete_line = "dm-",
          delete_buf = "dma",
          delete_bookmark = "dmb",
          set_bookmark0 = "mb0",
          set_bookmark1 = "mb1",
          set_bookmark2 = "mb2",
          set_bookmark3 = "mb3",
          set_bookmark4 = "mb4",
          set_bookmark5 = "mb5",
          set_bookmark6 = "mb6",
          set_bookmark7 = "mb7",
          set_bookmark8 = "mb8",
          next_bookmark = "m]",
          prev_bookmark = "m["
        }
      })
    end
  },
})
