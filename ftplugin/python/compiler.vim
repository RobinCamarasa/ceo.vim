if match(expand('%:t'), 'test_.*\.py') == 0
    compiler pytest
else
    compiler python
endif
