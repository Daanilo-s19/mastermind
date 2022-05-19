using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Media;
using GalaSoft.MvvmLight;

namespace Mastermind
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
           
        }

        
        List<Register> registerList = new List<Register>();


        public void SendFeedback(object sender, RoutedEventArgs e)
        {
            // Change button text when button is clicked.
            //  var button = (Button)sender;
            //  button.Content = "Hello, Avalonia!";


            if ((ComboBoxItem)VC.SelectedItem is null || (ComboBoxItem)VCPE.SelectedItem is null) return;
            
            
            var selectIncorrect = this.Find<ComboBox>("VCPE");
            var typeItemWrong = (ComboBoxItem)VCPE.SelectedItem;
            var incorrectPositionvalue = typeItemWrong.Content.ToString();
            selectIncorrect.SelectedIndex = 0;

            var selectCorrect = this.Find<ComboBox>("VC");
            var typeItemRight = (ComboBoxItem)VC.SelectedItem;
            var correctPositionValue = typeItemRight.Content.ToString();
            selectCorrect.SelectedIndex = 0;

            //AddRegister(correctPositionValue, incorrectPositionvalue);
        }

        private void AddRegister(string? correctPosition, string? incorrectPosition)
        {
            if (correctPosition is null || incorrectPosition is null) return;
            
            var input = "[" + correctPosition + " , " + incorrectPosition + "]";

            registerList = new List<Register>(registerList);

            registerList.Add(new Register { round = registerList.Count + 1, iaInput = " ", userInput = input });
            
            lvDataBinding.Items = registerList;
        }
    }

    public class Register
    {
        public int round { get; set; }
        public string iaInput { get; set; }

        public string userInput { get; set; }
    }
    
    
}