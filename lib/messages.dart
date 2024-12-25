class Messages
{
  final String message;

  Messages( this.message);


  factory Messages.feach(jsondata)
  {
    return Messages(jsondata['text']

    );
  }
}