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
    ada.text_io.put(format(fmt, args));
  end;

  procedure print(fmt: string) is
    args: value_list(1..0);
  begin
    print(fmt, args);
  end;

  procedure println(fmt: string; args: value_list) is
    str: constant string := format(fmt, args);
  begin
    if str(str'last) = ASCII.LF then
      ada.text_io.put(str);
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
    ada.text_io.put(file, format(fmt, args));
  end;

  procedure print(file: in out ada.text_io.file_type; fmt: string) is
    args: value_list(1..0);
  begin
    print(file, fmt, args);
  end;

  procedure println(file: in out ada.text_io.file_type; fmt: string; args: value_list) is
    str: constant string := format(fmt, args);
  begin
    if str(str'last) = ASCII.LF then
      ada.text_io.put(file, str);
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

  function format(fmt: string; args: value_list) return string is
  begin
    return "<format+args>"; -- TODO: implement me
  end;

  function format(fmt: string) return string is
    args: value_list(1..0);
  begin
    return format(fmt, args);
  end;

  --procedure format(str: in out string; fmt: string; args: value_list) is
  --begin
  --end;

  --procedure format(str: in out string; fmt: string) is
  --  args: value_list(1..0);
  --begin
  --  return format(str, fmt, args);
  --end;

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
