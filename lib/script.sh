# Create core folders and dummy files
for folder in constants exceptions utils network; do
  mkdir -p src/core/$folder
  echo "// ${folder}.dart" >src/core/$folder/${folder}.dart
done

# Create dio_client.dart
echo "// dio_client.dart" >src/core/network/dio_client.dart

# List of features
features=(auth home profile create_post myapplication explore viewapplication posts,)

# Loop through features and create folders + dummy files
for feature in "${features[@]}"; do
  for part in datasources models repositories_impl; do
    mkdir -p src/features/$feature/data/$part
    echo "// $part.dart" >src/features/$feature/data/$part/$part.dart
  done
  for part in entities repositories usecases; do
    mkdir -p src/features/$feature/domain/$part
    echo "// $part.dart" >src/features/$feature/domain/$part/$part.dart
  done

  mkdir -p src/features/$feature/presentation/controllers
  echo "// controllers.dart" >src/features/$feature/presentation/controllers/controllers.dart

  mkdir -p src/features/$feature/presentation/pages
  # Special case for auth
  if [[ "$feature" == "auth" ]]; then
    echo "// login_page.dart" >src/features/auth/presentation/pages/login_page.dart
    echo "// signup_page.dart" >src/features/auth/presentation/pages/signup_page.dart
  else
    echo "// ${feature}_page.dart" >src/features/$feature/presentation/pages/${feature}_page.dart
  fi
done

# Create app.dart
echo "// app.dart" >src/app.dart
