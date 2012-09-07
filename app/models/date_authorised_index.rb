class DateAuthorisedIndex < CachedModel
  set_table_name :Date_Authorised_Index
  has_many :Requests
end