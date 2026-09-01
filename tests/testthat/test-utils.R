test_that("zenodo_files() returns the files that are there", {
  directory <- withr::local_tempdir()
  file.create(file.path(directory, c("a.csv", "b.csv")))
  records <- list(
    files = stats::setNames(vector("list", 3L), c("a.csv", "b.csv", "c.csv"))
  )

  expect_identical(
    basename(zenodo_files(directory, records)),
    c("a.csv", "b.csv")
  )
  expect_identical(missing_zenodo_files(directory, records), "c.csv")
  expect_false(zenodo_files_exist(directory, records))

  file.create(file.path(directory, "c.csv"))
  expect_identical(missing_zenodo_files(directory, records), character(0))
  expect_true(zenodo_files_exist(directory, records))
  expect_length(zenodo_files(directory, records), 3L)
})
