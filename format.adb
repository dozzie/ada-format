package body format is
  function f(c: character) return formatter is
  begin
    return fmt: formatter do
      null; -- TODO: implement me
    end return;
  end;

  function f(s: string) return formatter is
  begin
    return fmt: formatter do
      null; -- TODO: implement me
    end return;
  end;

  function f(i: integer) return formatter is
  begin
    return fmt: formatter do
      null; -- TODO: implement me
    end return;
  end;

  function f(f: float) return formatter is
  begin
    return fmt: formatter do
      null; -- TODO: implement me
    end return;
  end;

  ----------------------------------------------------------------------------
  -- printing to STDOUT

  procedure print(fmt: string) is
  begin
    ada.text_io.put(format(fmt));
  end;

  procedure print(fmt: string; args: formatter_list) is
  begin
    ada.text_io.put(format(fmt, args));
  end;

  procedure println(fmt: string) is
    s: string := format(fmt);
  begin
    if s(s'last) = ASCII.LF then
      ada.text_io.put(s);
    else
      ada.text_io.put_line(s);
    end if;
  end;

  procedure println(fmt: string; args: formatter_list) is
    s: string := format(fmt, args);
  begin
    if s(s'last) = ASCII.LF then
      ada.text_io.put(s);
    else
      ada.text_io.put_line(s);
    end if;
  end;

  ----------------------------------------------------------------------------
  -- printing to a file

  --procedure print(file: in out ada.text_io.file_type; fmt: string) is
  --begin
  --end;

  --procedure print(file: in out ada.text_io.file_type; fmt: string; args: formatter_list) is
  --begin
  --end;

  --procedure println(file: in out ada.text_io.file_type; fmt: string) is
  --begin
  --end;

  --procedure println(file: in out ada.text_io.file_type; fmt: string; args: formatter_list) is
  --begin
  --end;

  ----------------------------------------------------------------------------
  -- printing to a string

  function format(fmt: string) return string is
  begin
    return "<format>"; -- TODO: implement me
  end;

  function format(fmt: string; args: formatter_list) return string is
  begin
    return "<format+args>"; -- TODO: implement me
  end;

  --procedure format(s: in out string; fmt: string) is
  --begin
  --end;

  --procedure format(s: in out string; fmt: string; args: formatter_list) is
  --begin
  --end;

  ----------------------------------------------------------------------------
  -- procedures inherited from ada.finalization.limited_controlled

  procedure initialize(f: in out formatter) is
  begin
    null; -- TODO: implement me
  end;

  procedure finalize(f: in out formatter) is
  begin
    null; -- TODO: implement me
  end;
end;
