page 50000 "Hello World"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Hello World';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(Message; Message)
                {
                    ApplicationArea = All;
                    Caption = 'Message';
                    ToolTip = 'Specifies a greeting message.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SayHello)
            {
                ApplicationArea = All;
                Caption = 'Say Hello';
                Image = Start;
                ToolTip = 'Displays a hello world message.';

                trigger OnAction()
                begin
                    Message(HelloWorldMsg);
                end;
            }
        }
    }

    var
        Message: Text[250];
        HelloWorldMsg: Label 'Hello, World!';
}
