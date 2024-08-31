return {
  {
    "DNLHC/glance.nvim",
    config = true,

    keys = {
      {
        "gD",
        "<cmd>Glance definitions<cr>",
        mode = "n",
        desc = "Glance definition",
      },
      {
        "gR",
        "<cmd>Glance references<cr>",
        mode = "n",
        desc = "Glance references",
      },
      {
        "gY",
        "<cmd>Glance type_definitions<cr>",
        mode = "n",
        desc = "Glance type definitions",
      },
      {
        "gM",
        "<cmd>Glance implementations<cr>",
        mode = "n",
        desc = "Glance implementations",
      },
    },
  },
}
