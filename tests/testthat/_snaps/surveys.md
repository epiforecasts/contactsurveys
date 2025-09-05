# surveys can be downloaded with download_survey()

    Code
      basename(peru_survey_files)
    Output
      [1] "2015_Grijalva_Peru_contact_common.csv"    
      [2] "2015_Grijalva_Peru_dictionary.xls"        
      [3] "2015_Grijalva_Peru_hh_common.csv"         
      [4] "2015_Grijalva_Peru_hh_extra.csv"          
      [5] "2015_Grijalva_Peru_participant_common.csv"
      [6] "2015_Grijalva_Peru_participant_extra.csv" 
      [7] "2015_Grijalva_Peru_sday.csv"              

---

    Code
      . <- download_survey(doi_peru, overwrite = FALSE)
    Message
      Skipping download.
      i Files already exist, and `overwrite = FALSE`
      i Set `overwrite = TRUE` to force a re-download.

# download_survey() is silent when verbose = FALSE

    Code
      . <- download_survey(doi_peru, verbose = FALSE)

