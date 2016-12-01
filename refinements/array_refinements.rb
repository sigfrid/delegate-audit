module ArrayRefinements
  refine Array do
    def compact_keys
      # [{"model_id"=>[nil, 1]}, {"model_id"=>[nil, 2]}] --> {"model_id"=>[[nil, nil], [1, 2]]}
      self.flat_map(&:to_a)
          .group_by(&:first)
          .map{ |key, value| [key, value.map(&:last).transpose] }
          .to_h
    end
  end
end
