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

  ----------------------------------------------------------
  -- print(fmt, arg1, ...) {{{

  procedure print(fmt: string; arg1: value) is
    args: value_list(1..1);
  begin
    args(1).str := arg1.str;

    print(fmt, args);

    for i in args'range loop
      args(i).str := null;
    end loop;
  end;

  procedure print(fmt: string; arg1, arg2: value) is
    args: value_list(1..2);
  begin
    args(1).str := arg1.str;
    args(2).str := arg2.str;

    print(fmt, args);

    for i in args'range loop
      args(i).str := null;
    end loop;
  end;

  procedure print(fmt: string; arg1, arg2, arg3: value) is
    args: value_list(1..3);
  begin
    args(1).str := arg1.str;
    args(2).str := arg2.str;
    args(3).str := arg3.str;

    print(fmt, args);

    for i in args'range loop
      args(i).str := null;
    end loop;
  end;

  procedure print(fmt: string; arg1, arg2, arg3, arg4: value) is
    args: value_list(1..4);
  begin
    args(1).str := arg1.str;
    args(2).str := arg2.str;
    args(3).str := arg3.str;
    args(4).str := arg4.str;

    print(fmt, args);

    for i in args'range loop
      args(i).str := null;
    end loop;
  end;

  procedure print(fmt: string; arg1, arg2, arg3, arg4, arg5: value) is
    args: value_list(1..5);
  begin
    args(1).str := arg1.str;
    args(2).str := arg2.str;
    args(3).str := arg3.str;
    args(4).str := arg4.str;
    args(5).str := arg5.str;

    print(fmt, args);

    for i in args'range loop
      args(i).str := null;
    end loop;
  end;

  -- }}}
  ----------------------------------------------------------

  procedure println(fmt: string; args: value_list) is
    str: constant string := sformat(fmt, args);
  begin
    if str'length > 0 and then str(str'last) = ASCII.LF then
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

  ----------------------------------------------------------
  -- println(fmt, arg1, ...) {{{

  procedure println(fmt: string; arg1: value) is
    args: value_list(1..1);
  begin
    args(1).str := arg1.str;

    println(fmt, args);

    for i in args'range loop
      args(i).str := null;
    end loop;
  end;

  procedure println(fmt: string; arg1, arg2: value) is
    args: value_list(1..2);
  begin
    args(1).str := arg1.str;
    args(2).str := arg2.str;

    println(fmt, args);

    for i in args'range loop
      args(i).str := null;
    end loop;
  end;

  procedure println(fmt: string; arg1, arg2, arg3: value) is
    args: value_list(1..3);
  begin
    args(1).str := arg1.str;
    args(2).str := arg2.str;
    args(3).str := arg3.str;

    println(fmt, args);

    for i in args'range loop
      args(i).str := null;
    end loop;
  end;

  procedure println(fmt: string; arg1, arg2, arg3, arg4: value) is
    args: value_list(1..4);
  begin
    args(1).str := arg1.str;
    args(2).str := arg2.str;
    args(3).str := arg3.str;
    args(4).str := arg4.str;

    println(fmt, args);

    for i in args'range loop
      args(i).str := null;
    end loop;
  end;

  procedure println(fmt: string; arg1, arg2, arg3, arg4, arg5: value) is
    args: value_list(1..5);
  begin
    args(1).str := arg1.str;
    args(2).str := arg2.str;
    args(3).str := arg3.str;
    args(4).str := arg4.str;
    args(5).str := arg5.str;

    println(fmt, args);

    for i in args'range loop
      args(i).str := null;
    end loop;
  end;

  -- }}}
  ----------------------------------------------------------

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
    if str'length > 0 and then str(str'last) = ASCII.LF then
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

  ----------------------------------------------------------
  -- placeholders {{{

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

  -- }}}
  ----------------------------------------------------------
  -- character decoding {{{

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

  function ucode(c: string) return natural is
    code: natural := 0;
  begin
    for i in c'range loop
      code := code * 16 + hex(c(i));
    end loop;
    return code;
  end;

  function ulen(c: string) return positive is
  begin
    case ucode(c) is
      when 16#0000# .. 16#007F# => return 1;
      when 16#0080# .. 16#07FF# => return 2;
      when 16#0800# .. 16#FFFF# => return 3;
      when others => return 4;
    end case;
  end;

  function unicode(c: string) return string is
    code: constant integer := ucode(c);
  begin
    case code is
      when 16#0000# .. 16#007F# =>
        return (
          1 => character'val(code)
        );
      when 16#0080# .. 16#07FF# =>
        -- 110xxxxx 10xxxxxx
        return (
          1 => character'val(2#11000000# + (code / 2 ** 6)),
          2 => character'val(2#10000000# + (code rem 2 ** 6))
        );
      when 16#0800# .. 16#FFFF# =>
        -- 1110xxxx 10xxxxxx 10xxxxxx
        return (
          1 => character'val(2#11100000# + (code / 2 ** 12)),
          2 => character'val(2#10000000# + ((code rem 2 ** 12) / 2 ** 6)),
          3 => character'val(2#10000000# + (code rem 2 ** 6))
        );
      when 16#10000# .. 16#10FFFF# =>
        -- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
        return (
          1 => character'val(2#11110000# + (code / 2 ** 18)),
          2 => character'val(2#10000000# + ((code rem 2 ** 18) / 2 ** 12)),
          3 => character'val(2#10000000# + ((code rem 2 ** 12) / 2 ** 6)),
          4 => character'val(2#10000000# + (code rem 2 ** 6))
        );
      when others =>
        -- invalid Unicode codepoint
        raise constraint_error; -- TODO: different error
    end case;
  end;

  -- }}}
  ----------------------------------------------------------
  -- output string {{{

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
            when 'u' =>
              if i + 4 > fmt'last then
                -- too short
                raise constraint_error; -- TODO: different error
              elsif (not is_hex(fmt(i + 1))) or (not is_hex(fmt(i + 2))) or
                    (not is_hex(fmt(i + 3))) or (not is_hex(fmt(i + 4))) then
                raise constraint_error; -- TODO: different error
              else
                len := len + ulen(fmt(i + 1 .. i + 4));
                i := i + 4;
              end if;
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

  procedure store_format(result: in out string;
                         fmt: string; args: value_list) is
    auto_n: integer := args'first;
    fi: integer := fmt'first;
    ri: integer := result'first;

    procedure result_put(c: character) is
    begin
      result(ri) := c;
      ri := ri + 1;
    end;
    procedure result_put(s: string) is
    begin
      result(ri .. ri + s'length - 1) := s;
      ri := ri + s'length;
    end;
  begin
    while fi < fmt'last loop
      case fmt(fi) is
        when '\' =>
          fi := fi + 1;
          case fmt(fi) is
            when '{' => result_put('{');
            when '}' => result_put('}'); -- symmetry with "\{"
            when ''' => result_put('"'); -- convenience code
            when '"' => result_put('"');
            when '\' => result_put('\');
            when '/' => result_put('/');
            when 'b' => result_put(ASCII.BS);
            when 'f' => result_put(ASCII.FF);
            when 'n' => result_put(ASCII.LF);
            when 'r' => result_put(ASCII.CR);
            when 't' => result_put(ASCII.HT);
            when 'x' =>
              -- invalid sequences ruled out by count_format()
              result_put(character'val(hex(fmt(fi + 1)) * 16 +
                                       hex(fmt(fi + 2))));
              fi := fi + 2;
            when 'u' =>
              -- invalid sequences ruled out by count_format()
              result_put(unicode(fmt(fi + 1 .. fi + 4)));
              fi := fi + 4;
            when others => null; -- ruled out by count_format()
          end case;
          fi := fi + 1;
        when '{' =>
          declare
            n: positive := 1;
          begin
            parse_placeholder(fmt, fi, auto_n, n);
            -- NOTE: `(n not in args'range)' ruled out by count_format()
            result_put(args(n).str.all);
          end;
          fi := fi + 1;
        when others =>
          result_put(fmt(fi));
          fi := fi + 1;
      end case;
    end loop;

    -- NOTE: fmt(i) being '\' or '{' is ruled out by count_format()

    if fi = fmt'last then -- can be past fmt'last, e.g. after "\n"
      result_put(fmt(fi));
    end if;
  end;

  -- }}}
  ----------------------------------------------------------

  function sformat(fmt: string; args: value_list) return string is
    length: constant natural := count_format(fmt, args);
  begin
    return result: string(1..length) do
      store_format(result, fmt, args);
    end return;
  end;

  function sformat(fmt: string) return string is
    args: value_list(1..0);
  begin
    return sformat(fmt, args);
  end;

  procedure sformat(str: in out string; fmt: string; args: value_list) is
    length: constant natural := count_format(fmt, args);
  begin
    if str'length < length then
      raise constraint_error; -- TODO: different error
    end if;
    store_format(str, fmt, args);
  end;

  procedure sformat(str: in out string; fmt: string) is
    args: value_list(1..0);
  begin
    sformat(str, fmt, args);
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

----------------------------------------------------------------------------
-- vim:ft=ada:foldmethod=marker
