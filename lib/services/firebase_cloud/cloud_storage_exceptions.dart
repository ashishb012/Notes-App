class CloudStorageException implements Exception {
  const CloudStorageException();
}

// CRUD
// C
class CouldNotCreateNoteException extends CloudStorageException {}

// R
class CouldNotGetAllNotesException extends CloudStorageException {}

// U
class CouldNotUpdateNoteException extends CloudStorageException {}

//D
class CouldNotDeleteNoteException extends CloudStorageException {}
