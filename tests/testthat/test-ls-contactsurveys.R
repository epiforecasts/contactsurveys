test_that("ls_contactsurveys() works", {
  file_paths <- ls_contactsurveys()
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
    ls_contactsurveys = function(dir) NULL
  )
  expect_message(
    delete_contactsurveys_files(),
    "There are no files to delete"
  )
})
