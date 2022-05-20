using System;
using System.Collections.Generic;
using Avalonia.Controls;
using Avalonia.Interactivity;

namespace Mastermind.UI;

public partial class MainWindow : Window {
  public MainWindow() {
    InitializeComponent();
  }


  List<Register> _registerList = new List<Register>();


  public void SendFeedback(object sender, RoutedEventArgs e) {
    // Change button text when button is clicked.
    //  var button = (Button)sender;
    //  button.Content = "Hello, Avalonia!";


    if (VC.SelectedItem is null || VCPE.SelectedItem is null) return;


    var selectIncorrect = this.Find<ComboBox>("VCPE");
    var typeItemWrong = (ComboBoxItem)VCPE.SelectedItem;
    var incorrectPositionvalue = typeItemWrong.Content.ToString();
    selectIncorrect.SelectedIndex = 0;

    var selectCorrect = this.Find<ComboBox>("VC");
    var typeItemRight = (ComboBoxItem)VC.SelectedItem;
    var correctPositionValue = typeItemRight.Content.ToString();
    selectCorrect.SelectedIndex = 0;

    AddRegister(correctPositionValue, incorrectPositionvalue);
  }

  private void AddRegister(string? correctPosition, string? incorrectPosition) {
    if (correctPosition is null || incorrectPosition is null) return;

    var input = $"[{correctPosition}, {incorrectPosition}]";

    _registerList = new List<Register>(_registerList);

    _registerList.Add(new Register(_registerList.Count + 1, String.Empty, input));

    lvDataBinding.Items = _registerList;
  }
}

public record Register(int Round, string IaInput, string UserInput);
