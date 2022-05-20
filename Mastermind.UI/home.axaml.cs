using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;

namespace Mastermind.UI;

public partial class home : Window {
  public home() {
    InitializeComponent();
#if DEBUG
    this.AttachDevTools();
#endif
  }

  private void InitializeComponent() {
    AvaloniaXamlLoader.Load(this);
  }
}
