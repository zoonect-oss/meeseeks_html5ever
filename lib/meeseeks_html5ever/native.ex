defmodule MeeseeksHtml5ever.Native do
  @moduledoc false

  mix_config = Mix.Project.config()
  version = mix_config[:version]
  env_config = Application.compile_env(:meeseeks_html5ever, MeeseeksHtml5ever, [])

  use RustlerPrecompiled,
    nif_versions: ~w(2.15),
    otp_app: :meeseeks_html5ever,
    crate: "meeseeks_html5ever_nif",
    mode: :release,
    base_url: "https://github.com/mischov/meeseeks_html5ever/releases/download/v#{version}",
    force_build:
      System.get_env("MEESEEKS_HTML5EVER_BUILD") in ["1", "true"] or
        env_config[:build_from_source],
    targets:
      Enum.uniq(["aarch64-unknown-linux-musl" | RustlerPrecompiled.Config.default_targets()]),
    version: version

  def parse_html(_binary), do: err()
  def parse_xml(_binary), do: err()

  defp err(), do: :erlang.nif_error(:nif_not_loaded)
end
