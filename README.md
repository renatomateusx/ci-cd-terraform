## Pipeline de CI/CD com Jenkins e Terraform
Este projeto demonstra como configurar um pipeline de Integração e Entrega Contínua (CI/CD) utilizando Jenkins para automatizar o deploy de uma aplicação, além de provisionar a infraestrutura necessária com Terraform.

## Descrição do Processo
O pipeline de CI/CD automatiza todo o processo de deploy de uma aplicação e o provisionamento da infraestrutura na nuvem. O processo é dividido em diversas etapas (stages) que são executadas automaticamente pelo Jenkins.

## Principais Etapas
Checkout do Código da Aplicação: Jenkins faz o checkout do repositório onde o código da aplicação está armazenado.
Checkout do Código de Infraestrutura: Jenkins também faz o checkout do repositório contendo o código de infraestrutura (arquivos Terraform).
Provisionamento de Infraestrutura: Utilizando os arquivos Terraform, o Jenkins provisiona a infraestrutura necessária (servidores, redes, etc.) na nuvem.

## Build e Deploy da Aplicação: 
A aplicação é construída usando Docker e é implantada em containers.
## Notificações e Logs: J
enkins exibe o status do pipeline ao final do processo, indicando sucesso ou falha.

## Requisitos
Para rodar este pipeline, você precisará garantir que os seguintes requisitos estão configurados:

Jenkins instalado e configurado.
Terraform instalado no ambiente onde o Jenkins executará o pipeline.
Docker instalado no servidor Jenkins para construir e rodar os containers.
Acesso à sua plataforma de nuvem (AWS, Azure, GCP) para provisionamento de infraestrutura.
Estrutura do Projeto
Este projeto utiliza dois repositórios Git:

Repositório da Aplicação: Contém o código-fonte da aplicação e o arquivo Jenkinsfile para definir o pipeline.
Repositório de Infraestrutura: Contém os arquivos Terraform que descrevem os recursos de infraestrutura.
Jenkinsfile
O pipeline é definido no arquivo Jenkinsfile, localizado no repositório da aplicação. Ele contém as seguintes etapas (stages):

```
pipeline {
    agent any

    stages {
        // 1. Checkout do código da aplicação
        stage('Checkout Code') {
            steps {
                git 'https://github.com/yourusername/my-app-repo.git'
            }
        }

        // 2. Checkout do código de infraestrutura (Terraform)
        stage('Checkout Terraform Code') {
            steps {
                git 'https://github.com/yourusername/infra-terraform-repo.git'
            }
        }

        // 3. Provisionar infraestrutura com Terraform
        stage('Deploy Infrastructure') {
            steps {
                sh '''
                cd infra-terraform-repo
                terraform init
                terraform apply -auto-approve
                '''
            }
        }

        // 4. Build e deploy da aplicação com Docker
        stage('Build and Deploy Application') {
            steps {
                sh '''
                docker build -t my-app .
                docker run -d -p 80:80 my-app
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
```
Terraform
Os arquivos Terraform que descrevem a infraestrutura estão armazenados em um repositório separado. Um exemplo básico de main.tf para provisionar uma instância EC2 na AWS:

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}
```

Passo a Passo de Configuração
1. Configurar Jenkins
Instale o Jenkins no seu ambiente.
Configure as credenciais para acessar os repositórios Git.
Certifique-se de que o Jenkins tenha acesso ao Terraform e ao Docker.
2. Criar o Repositório da Aplicação
Suba o código da aplicação no GitHub ou outro sistema de controle de versão.
Adicione o arquivo Jenkinsfile para definir o pipeline.
3. Criar o Repositório de Infraestrutura
Suba os arquivos Terraform no GitHub, em um repositório separado.
4. Configurar o Pipeline no Jenkins
Crie um novo pipeline no Jenkins.
Aponte o pipeline para o repositório que contém o Jenkinsfile.
Configure as permissões e credenciais necessárias para o Jenkins acessar os repositórios e a nuvem.
5. Executar o Pipeline
Execute o pipeline manualmente ou configure-o para rodar automaticamente após cada push no repositório.
Acompanhe as etapas de execução diretamente no console do Jenkins.
Verifique se a infraestrutura foi provisionada corretamente e se a aplicação foi implantada.
Conclusão
Este projeto utiliza uma abordagem moderna de CI/CD para automatizar o provisionamento de infraestrutura e o deploy de uma aplicação. Usando Jenkins e Terraform, é possível garantir que a infraestrutura e o deploy sejam realizados de forma consistente, eficiente e automatizada.