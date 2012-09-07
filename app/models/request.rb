class Request < CachedModel
  belongs_to :OutstandingWorkIndex
  belongs_to :DateAuthorisedIndex
  has_many :Result_Sets
end
