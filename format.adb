with ada.unchecked_deallocation;

package body format is
  ----------------------------------------------------------------------------
  -- basics

  function f(val: character) return value is
    str: constant string := (1 => val);
  begin
    -- TODO: prefix, suffix
    return make_value(str);
  end;

  function f(val: string) return value is
  begin
    -- TODO: prefix, suffix
    return make_value(val);
  end;

  function f(val: integer) return value is
    -- TODO: base, prefix, suffix
    str: constant string := integer'image(val);
    i: integer := str'first;
  begin
    while str(i) = ' ' loop
      i := i + 1;
    end loop;
    return make_value(str(i..str'last));
  end;

  function f(val: float) return value is
  begin
    -- TODO: prefix, suffix, precision, notation
    return make_value(float'image(val));
  end;

  ----------------------------------------------------------------------------
  -- extending formatter

  function make_value(val: string) return value is
  begin
    return f: value do
      f.str := new string(1..val'length);
      f.str.all := val;
    end return;
  end;

  ----------------------------------------------------------------------------
  -- printing to STDOUT

  procedure print(fmt: string; args: value_list) is
  begin
    ada.text_io.put(sformat(fmt, args));
  end;

  procedure print(fmt: string) is
    args: value_list(1..0);
  begin
    print(fmt, args);
  end;

  procedure println(fmt: string; args: value_list) is
    str: constant string := sformat(fmt, args);
  begin
    if str(str'last) = ASCII.LF then
      ada.text_io.put_line(str(str'first .. str'last - 1));
    else
      ada.text_io.put_line(str);
    end if;
  end;

  procedure println(fmt: string) is
    args: value_list(1..0);
  begin
    println(fmt, args);
  end;

  ----------------------------------------------------------------------------
  -- printing to a file

  procedure print(file: in out ada.text_io.file_type; fmt: string; args: value_list) is
  begin
    ada.text_io.put(file, sformat(fmt, args));
  end;

  procedure print(file: in out ada.text_io.file_type; fmt: string) is
    args: value_list(1..0);
  begin
    print(file, fmt, args);
  end;

  procedure println(file: in out ada.text_io.file_type;
                    fmt: string; args: value_list) is
    str: constant string := sformat(fmt, args);
  begin
    if str(str'last) = ASCII.LF then
      ada.text_io.put_line(file, str(str'first .. str'last - 1));
    else
      ada.text_io.put_line(file, str);
    end if;
  end;

  procedure println(file: in out ada.text_io.file_type; fmt: string) is
    args: value_list(1..0);
  begin
    println(file, fmt, args);
  end;

  ----------------------------------------------------------------------------
  -- printing to a string

  procedure parse_placeholder(fmt: in string; start: in out integer;
                              auto_n: in out positive; n: in out positive) is
    nn: natural := 0;
    i: integer := start;
  begin
    -- TODO: parse out the field width

    if fmt(i) /= '{' then
      return;
    end if;

    if i = fmt'last then
      -- last character leaves no space for a placeholder, so it's an error
      raise constraint_error; -- TODO: different error
    end if;
    i := i + 1;

    if fmt(i) = '}' then
      -- automatic variables, short-circuit
      n := auto_n;
      auto_n := auto_n + 1;
      start := i;
      return;
    end if;

    -- NOTE: keep one unchecked character at the end of string; if we got that
    -- far, it should be '}' or an error will be raised
    while i < fmt'last loop
      exit when fmt(i) > '9' or fmt(i) < '0';
      nn := nn * 10 + character'pos(fmt(i)) - character'pos('0');
      i := i + 1;
    end loop;

    if fmt(i) /= '}' or nn = 0 then
      -- not a proper placeholder ending or no valid argument identifier
      raise constraint_error; -- TODO: different error
    end if;
    n := nn; -- `nn = 0' was ruled out by above `if'
    start := i;
  end;

  function is_hex(c: character) return boolean is
  begin
    return (c in '0'..'9') or (c in 'A'..'F') or (c in 'a'..'f');
  end;

  function hex(c: character) return natural is
  begin
    case c is
      when '0' .. '9' => return      character'pos(c) - character'pos('0');
      when 'A' .. 'F' => return 10 + character'pos(c) - character'pos('A');
      when 'a' .. 'f' => return 10 + character'pos(c) - character'pos('a');
      when others => raise constraint_error; -- TODO: different error
    end case;
  end;

  function count_format(fmt: string; args: value_list) return natural is
    len: natural := 0;
    i: integer := fmt'first;
    auto_n: integer := args'first;
  begin
    -- NOTE: remember to include the last character
    while i < fmt'last loop
      case fmt(i) is
        when '\' =>
          i := i + 1;
          case fmt(i) is
            when '{' => len := len + 1;
            when '}' => len := len + 1; -- symmetry with "\{"
            when ''' => len := len + 1; -- convenience code
            when '"' => len := len + 1;
            when '\' => len := len + 1;
            when '/' => len := len + 1;
            when 'b' => len := len + 1;
            when 'f' => len := len + 1;
            when 'n' => len := len + 1;
            when 'r' => len := len + 1;
            when 't' => len := len + 1;
            when 'x' =>
              if i + 2 > fmt'last then
                -- too short
                raise constraint_error; -- TODO: different error
              elsif (not is_hex(fmt(i + 1))) or (not is_hex(fmt(i + 2))) then
                raise constraint_error; -- TODO: different error
              else
                i := i + 2;
                len := len + 1;
              end if;
            -- TODO: \uCCCC
            -- invalid escape sequence
            when others => raise constraint_error; -- TODO: different error
          end case;
          i := i + 1;
        when '{' =>
          declare
            n: positive := 1;
          begin
            parse_placeholder(fmt, i, auto_n, n);
            if n not in args'range then
              raise constraint_error; -- TODO: different error
            end if;
            len := len + args(n).str'length;
          end;
          i := i + 1;
        when others =>
          len := len + 1;
          i := i + 1;
      end case;
    end loop;

    if i = fmt'last then -- can be past fmt'last, e.g. after "\n"
      case fmt(i) is
        when '\' => raise constraint_error; -- TODO: different error
        when '{' => raise constraint_error; -- TODO: different error
        when others => len := len + 1;
      end case;
    end if;

    return len;
  end;

  function sformat(fmt: string; args: value_list) return string is
    total_len: constant natural := count_format(fmt, args);
    result: string(1..total_len);
    auto_n: integer := args'first;
    fi: integer := fmt'first;
    ri: integer := result'first;
  begin
    while fi < fmt'last loop
      case fmt(fi) is
        when '\' =>
          fi := fi + 1;
          case fmt(fi) is
            when '{' => result(ri) := '{'; ri := ri + 1;
            when '}' => result(ri) := '}'; ri := ri + 1; -- symmetry with "\{"
            when ''' => result(ri) := '"'; ri := ri + 1; -- convenience code
            when '"' => result(ri) := '"'; ri := ri + 1;
            when '\' => result(ri) := '\'; ri := ri + 1;
            when '/' => result(ri) := '/'; ri := ri + 1;
            when 'b' => result(ri) := ASCII.BS; ri := ri + 1;
            when 'f' => result(ri) := ASCII.FF; ri := ri + 1;
            when 'n' => result(ri) := ASCII.LF; ri := ri + 1;
            when 'r' => result(ri) := ASCII.CR; ri := ri + 1;
            when 't' => result(ri) := ASCII.HT; ri := ri + 1;
            when 'x' =>
              -- invalid sequences ruled out by count_format()
              result(ri) := character'val(hex(fmt(fi + 1)) * 16 +
                                          hex(fmt(fi + 2)));
              ri := ri + 1;
              fi := fi + 2;
            -- TODO: \uCCCC
            when others => null; -- ruled out by count_format()
          end case;
          fi := fi + 1;
        when '{' =>
          declare
            n: positive := 1;
          begin
            parse_placeholder(fmt, fi, auto_n, n);
            -- NOTE: `(n not in args'range)' ruled out by count_format()
            result(ri .. ri + args(n).str'length - 1) := args(n).str.all;
            ri := ri + args(n).str'length;
          end;
          fi := fi + 1;
        when others =>
          result(ri) := fmt(fi);
          ri := ri + 1;
          fi := fi + 1;
      end case;
    end loop;

    -- NOTE: fmt(i) being '\' or '{' is ruled out by count_format()

    if fi = fmt'last then -- can be past fmt'last, e.g. after "\n"
      result(ri) := fmt(fi);
    end if;

    return result;
  end;

  function sformat(fmt: string) return string is
    args: value_list(1..0);
  begin
    return sformat(fmt, args);
  end;

  procedure sformat(str: in out string; fmt: string; args: value_list) is
    result: constant string := sformat(fmt, args);
  begin
    -- NOTE: this will raise CONSTRAINT_ERROR if the output string is too
    -- short
    str(str'first .. str'first + result'length - 1) := result;
  end;

  procedure sformat(str: in out string; fmt: string) is
    result: constant string := sformat(fmt);
  begin
    -- NOTE: this will raise CONSTRAINT_ERROR if the output string is too
    -- short
    str(str'first .. str'first + result'length - 1) := result;
  end;

  ----------------------------------------------------------------------------
  -- procedures inherited from ada.finalization.limited_controlled

  procedure initialize(f: in out value) is
  begin
    f.str := null;
  end;

  procedure finalize(f: in out value) is
    procedure free is new ada.unchecked_deallocation(string, string_ptr);
  begin
    if f.str /= null then
      free(f.str);
    end if;
  end;
end;
