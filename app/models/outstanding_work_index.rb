class OutstandingWorkIndex < CachedModel
  set_table_name :Outstanding_Work_Index
  has_many :Requests
  has_many :Result_Sets
end
