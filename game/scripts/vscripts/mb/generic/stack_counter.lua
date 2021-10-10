--------------------------------------------------------------------------------
-- Helper: stack_counter RetATValue( t, counterSwap)
function Stack_RetATValue(t, counterSwap)
    local j, n = 1, #t;

    for i=1,n do
        if (counterSwap(i, j)) then
            -- Swap i's (duration/counter) value to j's position
            if (i ~= j) then
                t[j] = t[i];
                t[i] = nil; 
            end
            j = j + 1; -- Increment position of j.
        else
            t[i] = nil;
        end
    end

    return t;
end