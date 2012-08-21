my $c = {
 engine_config => {
  index       => [qw( index )],
   facets      => {
       names       => [qw( thread_title text )],
       sample_size => 10_000,
   },
   fields      => [qw( thread_title text )], 
   indexer_config => {
       config => {
           MetaNames => 'thread_title text',
           PropertyNames => 'thread_title text',
           PropertyNameAlias => 'swishtitle thread_title swishdescription text',
           UndefinedMetaTags => 'auto',
           DefaultContents => 'TXT',
           FuzzyIndexingMode => 'Stemming_en1',
       }
   },
   searcher_config => {
        find_relevant_fields => 1,
   },
   hiliter_config  => { class => 'search_match', tag => 'b' },
 }
};
