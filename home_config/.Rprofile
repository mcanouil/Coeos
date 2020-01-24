if (interactive() & "usethis" %in% utils::installed.packages()[, "Package"]) {
  usethis::ui_todo('Load {usethis::ui_path(".Rprofile")}')
  usethis::ui_todo('Write/load {usethis::ui_path(".Renviron")}')
  readRenviron(path = "~")
  Sys.setenv("LANGUAGE" = "en_GB.UTF-8")
  usethis::ui_todo('Set {usethis::ui_value("options")}')
  options(
    menu.graphics = FALSE,
    reprex.advertise = FALSE,
    error = rlang::entrace, 
    rlang_backtrace_on_error = "branch",
    usethis.protocol = "https",
    usethis.description = list(Version = "0.0.0.9000")
  )

  usethis::ui_done("{usethis::ui_field('menu.graphics')} set to {usethis::ui_value(options('menu.graphics'))}")
  usethis::ui_done("{usethis::ui_field('reprex.advertise')} set to {usethis::ui_value(options('reprex.advertise'))}")
  usethis::ui_done("{usethis::ui_field('usethis.protocol')} set to {usethis::ui_value(options('usethis.protocol'))}")
  usethis::ui_done("{usethis::ui_field('error')} set to {usethis::ui_value('rlang::entrace')}")
  usethis::ui_done("{usethis::ui_field('rlang_backtrace_on_error')} set to {usethis::ui_value(options('rlang_backtrace_on_error'))}")
  usethis::ui_done("{usethis::ui_field('prompt')} set to {usethis::ui_value(options('prompt'))}")
  usethis::ui_todo('Load packages')
  invisible(lapply(
    X = c("devtools", "usethis", "testthat", "reprex"),
    FUN = function(x) {
      if (suppressMessages(require(x, character.only = TRUE))) {
        usethis::ui_done(usethis::ui_value(x))
      } else {
        usethis::ui_oops(usethis::ui_value(x))
      }
    }
  ))
}
