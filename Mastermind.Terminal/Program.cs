using System;
using System.IO;
using SbsSW.SwiPlCs;
using SbsSW.SwiPlCs.Exceptions;

if (!PlEngine.IsInitialized) {
  var path = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory())!.ToString(), "knowledge", "index.pl");
  Console.WriteLine(path);
  Console.WriteLine(File.Exists(path));
  PlEngine.Initialize(new string[] { "-l", path });
}

Console.WriteLine("Hello, World!");

try {
  using var q = new PlQuery("list_to_set([4,4,4,4,2,4], Sf), gera_codigo(Sf, X).");
  foreach (var v in q.SolutionVariables) {
    Console.WriteLine(v["Child"].ToString());
  }
} catch (PlException e) {
  Console.WriteLine(e.MessagePl);
  Console.WriteLine(e.Message);
} catch (Exception e) {
  Console.WriteLine(e);
} finally {
  PlEngine.PlCleanup();
}

