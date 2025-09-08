test_that("ls_contactsurveys() works", {
  file_paths <- ls_contactsurveys()
  expect_true(all(is.character(file_paths)))
  expect_true(all(file.exists(file_paths)))
})

test_that("delete_contactsurveys_files() errors", {
  local_mocked_bindings(
    dir.exists = function(paths) FALSE
  )
  expect_error(
    delete_contactsurveys_files(),
    "Directory not found"
  )
})

test_that("delete_contactsurveys_files() messages", {
  local_mocked_bindings(
    dir.exists = function(paths) TRUE,
    ls_contactsurveys = function(dir) character(0)
  )
  expect_message(
    delete_contactsurveys_files(),
    "There are no files to delete"
  )
})
