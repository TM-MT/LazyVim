return {
  {
    "folke/sidekick.nvim",
    opts = {
      nes = { enabled = false },
      cli = {
        tools = {
          -- copilot alraedy has deault config but I provide additional options
          -- for display issue
          -- see https://github.com/folke/sidekick.nvim/issues/258#issuecomment-4049190203
          -- copilot = {
          --   cmd = { "copilot", "--alt-screen" },
          -- },
        },
        prompts = {
          explain_changes = [[Please explain the latest changes by function from three perspectives:
          functionality, changes, and scope of impact of the changes.]],
          review_staged_changes = [[ステージされた変更を確認し、以下の項目をレビューしてください
          - [ ] プロジェクトのコーディング規約に従っているか
          - [ ] コードの配置はリポジトリの設計思想に照らし合わせて適切か
          - [ ] 設計の一貫性が崩れることはないか
          - [ ] セキュリティ観点で懸念はないか
          - [ ] コードの重複はないか
          - [ ] 適切な粒度でコメントがあるか。コードを説明するだけのコメントは不要です。一見すると不可解な実装についてなぜその実装をしているのか、将来のメンテナーがわかるようになっているか
          - [ ] 変更内容に対して単体テストに過不足はないか
          - [ ] エラーケースや例外が適切に処理されているか
          - [ ] 空配列・null・境界値など異常系・エッジケースが考慮されているか
          - [ ] 変数・関数・クラス名が意図を正確に表しているか
          - [ ] コメントアウトや不要なデバッグログが残っていないか

          変更内容がリファクタリングの場合は、追加で以下もチェックしてください
          - [ ] API・インターフェースに意図せず変更していないか

          また以下の観点でレビューして改善案があれば提案してください
          - 同じコードをより簡潔かつ可読性を損なわずにかけるとき
          - 可読性を損なわずにパフォーマンスを向上できるとき
          ]],
        },
      },
    },
    keys = {
      {
        "<leader>as",
        function()
          require("sidekick.cli").select({ filter = { installed = true } })
        end,
        mode = { "n", "v", "t", "x" },
        desc = "Select CLI (Installed)",
      },
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle({ name = "copilot", focus = true })
        end,
        mode = { "n", "v", "t", "x" },
        desc = "Copilot",
      },
      {
        "<leader>al",
        function()
          require("sidekick.cli").send({ msg = "{line}" })
        end,
        mode = { "n", "v" },
        desc = "Send Line",
      },
    },
  },
}
